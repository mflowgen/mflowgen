/*******************************************************************************

	Written by Ivan Bukreyev
	Last modified on 3/19/2018
	Implements duty-cycling controller FSM for PCO nodes
	duty_out is the duty-cycle signal for the system with NDUTYL to NDUTYH duty window
	FSM description
		1) idle_s: default/reset state
		2) desync_s: start of synchronization process. PCO reset tracker is enabled
			after NPULSE consecutive lead/slave resets, advance to synclead_s/syncslave_s
		3) synclead_s: synchronized as a lead node, enable duty_out for NDUTY PCO cycles
		4) syncslave_s: synchronized as a slave node, enable duty_out for NDUTY PCO cycles
		5) checklead_s: disable duty_out and check synchronization
			on a forced reset, return to desync_s
			on a natural reset, return to synclead_s
		6) checklave_s: temporarily disable duty_out and check synchronization
			on a forced reset, return to syncslave_s
			on a natural reset, return to desync_s

	Note: could optimize counter usage with logic

*******************************************************************************/

module controller #(parameter CNTRbit = 13)(
input		clk,
input		greset_n,
input		enable,
input		pco_pulse_out,
input		pco_pulse_type,
input		[CNTRbit-1:0] cntr_pco,
input		[CNTRbit-1:0] NDUTYH,
input		[CNTRbit-1:0] NDUTYL,
input		[CNTRbit-1:0] NPULSE,
input		[CNTRbit-1:0] NDUTY,
output reg	duty_out,
output reg	[2:0] state,
output wire	[3:0] debug );


localparam sate_bits = 3;
localparam [sate_bits-1:0] idle_s      = 3'd0;
localparam [sate_bits-1:0] desync_s    = 3'd1;
localparam [sate_bits-1:0] synclead_s  = 3'd2;
localparam [sate_bits-1:0] syncslave_s = 3'd3;
localparam [sate_bits-1:0] checklead_s = 3'd4;
localparam [sate_bits-1:0] checklave_s = 3'd5;
localparam zeros = {(CNTRbit){1'b0}};


reg [sate_bits-1:0] next_state;
reg [CNTRbit-1:0] cntr1_slave;
reg [CNTRbit-1:0] cntr1_lead;
reg [CNTRbit-1:0] cntr2;
wire natural_reset;
wire forced_reset;
wire synchronized;
wire duty_out_en;
reg sync_slave;
reg sync_lead;
reg cntr1_rst;
reg cntr2_rst;


assign debug = {cntr2_rst, cntr1_rst, sync_slave, sync_lead};
assign natural_reset = pco_pulse_out && ~pco_pulse_type;
assign forced_reset = pco_pulse_out && pco_pulse_type;
assign synchronized = sync_lead || sync_slave;
assign duty_out_en = (cntr_pco >= NDUTYL) && (cntr_pco <= NDUTYH) && synchronized;

// Generate duty_out signal
always @(posedge clk) begin
	if (~greset_n) begin
		duty_out <= 1'b0;
	end else if (enable) begin
		duty_out <= duty_out_en;
	end
end

// PCO reset tracker
always @(posedge clk) begin
	if (~greset_n || cntr1_rst) begin
		cntr1_lead <= zeros;
		cntr1_slave <= zeros;
	end else if (enable) begin
		if (forced_reset) begin
			if (cntr_pco <= NDUTYH) begin // premature reset: probably from a random node
				cntr1_lead <= zeros;
				cntr1_slave <= zeros;
			end else begin // within-range reset: probably from a faster node
				//cntr1_lead <= zeros;
				cntr1_slave <= cntr1_slave + 1'b1;
			end
		end else if (natural_reset) begin // either fastest or lonely node
			cntr1_lead <= cntr1_lead + 1'b1;
			//cntr1_slave <= zeros;
		end
	end
end

// Duty-cycle duration counter before synchronization check
always @(posedge clk) begin
	if (~greset_n || cntr2_rst) begin
		cntr2 <= zeros;
	end else if (enable) begin
		if (pco_pulse_out && synchronized) begin
			if (cntr2 <= NDUTY) begin
				cntr2 <= cntr2 + 1'b1;
			end
		end
	end
end

// State transitions
always @(posedge clk) begin
	if (~greset_n) begin
		state <= idle_s;
	end else if (enable) begin
		state <= next_state;
	end
end

// State logic
 always @(*) begin
	sync_lead = 1'b0;
	sync_slave = 1'b0;
	cntr1_rst = 1'b0;
	cntr2_rst = 1'b0;
	next_state = idle_s;
	case (state)
		idle_s: begin
			if (enable) begin
				next_state = desync_s;
				cntr1_rst = 1'b1;
			end else begin
				next_state = idle_s;
			end
		end

		desync_s: begin
			if (cntr1_lead == NPULSE) begin
				next_state = synclead_s;
				cntr2_rst = 1'b1;
			end else if (cntr1_slave == NPULSE) begin
				next_state = syncslave_s;
				cntr2_rst = 1'b1;
			end else begin
				next_state = desync_s;
			end
		end

		synclead_s: begin
			sync_lead = 1'b1;
			if (cntr2 <= NDUTY) begin
				next_state = synclead_s;
			end else begin
				next_state = checklead_s;
			end
		end

		syncslave_s: begin
			sync_slave = 1'b1;
			if (cntr2 <= NDUTY) begin
				next_state = syncslave_s;
			end else begin
				next_state = checklave_s;
			end
		end

		checklead_s: begin
			if (natural_reset) begin
				next_state = synclead_s;
				cntr2_rst = 1'b1;
			end else if (forced_reset) begin
				next_state = desync_s;
				cntr1_rst = 1'b1;
			end else begin
				next_state = checklead_s;
			end
		end

		checklave_s: begin
			if (forced_reset) begin
				next_state = syncslave_s;
				cntr2_rst = 1'b1;
			end else if (natural_reset) begin
				next_state = desync_s;
				cntr1_rst = 1'b1;
			end else begin
				next_state = checklave_s;
			end
		end

		default: begin
			next_state = idle_s;
		end
	endcase
end


endmodule // module controller

/*******************************************************************************

	Written by Ivan Bukreyev
	Last modified on 3/26/2018
	Correlator tapeout top-level module

	ASIC recipe
		1) Dimensions: 1 mm x 1 mm without pads and power ring
		2) command line
			cat correlator_top.v spcore.v diffdet.v spcore_slice.v pco.v controller.v pulsegen.v spi.v > ivan_top.v
		3) TAPCELLBWP7T cell placement
			even rows : 0 ------  x ----- 2x ----- 3x ----- ...
			odd rows  : 0 -- x/2 --- 3x/2 --- 5x/2 --- ...
			x = 59 um seems to work
		4) Layout priority: Obey TAPCELLBWP7T rule -> insert logic -> insert DCAPx -> insert FILLx
		5) Pin placement
			Top (left-to-right)   :
			Right (top-to-bottom) :
			Bottom (left-to-right):

	ASIC generation
		in rtl
		cat *.v -> top.v
		cd /home/ib264/work/asic-ivan/dc-syn
		make
		cd ../innovus/test
		./foo.sh
		cd results
		cd /home/ib264/work/asic-ivan/innovus/test/plugins		

	ASIC report files
		~/work/asic-ivan/dc-syn/current-dc/reports
			correlator_top.mapped.qor.rpt
			correlator_top.mapped.area.rpt
			../log/dc.log

	Global signal description
		1) clk1: First main clock. Target frequency is 10 MHz @ 0 phase
		2) clk2: Second main clock. Target frequency is 10 MHz @ 90 phase
		3) clkpco: PCO main clock. Target frequency is 20 MHz @ any phase
		4) spiclk: SPI programming clock. No special target, could be arbitrarily slow
		5) spiload: Technically a clock, Loads active registers in module spi. No special target, could be arbitrarily slow
		6) greset_n: Global active-low reset. Always synchronous to a module clock
			This signal could be de-asserted at any time and does not have any special timing requirements
			Note: adding "or negedge greset_n" to flops to reduces logic size by a significant amount (at least in fpga)

	Dedicated Inputs (32 pins)
		VDD (2 pins)
		VSS (2 pins)
		clk1
		clk2
		clkpco
		spiclk
		greset_n
		spidin
		spiload
		debug_in
		ADC_I/ADC_Q (20 pins)
	Multiplexed Outputs (4 pins, 20 signals)
		pulsegen_out
		spidout
		vpeak
		vpeak1
		vpeak2
		pco_pulse_out
		pco_pulse_type
		duty_out
		state_ctrl[2:0];
		debug_pco[3:0];
		debug_ctrl[3:0];

	Parameter description
		1) ADCbit: Specifies ADC's resolution and consequently, correlator width
		2) SEQbit: Specifies maximum length the correlator
		3) PRCNbit: Described in detail in 'spcore_slice' module
		4) CNTRbit: Specifies width of pco-related counters
		5) CONFIGbit: Number of configuration bits used for testing

	ADC_I/ADC_Q format: (ADCbit)-bit two's complement
	Typical 10-bit ADC output formats
		|Input Voltage   | Offset bin   | 2's comp     |
		|----------------|--------------|--------------|
		| 511/512 x VREF | 11 1111 1111 | 01 1111 1111 |
		|   1/512 x VREF | 10 0000 0001 | 00 0000 0001 |
		|   0/512 x VREF | 10 0000 0000 | 00 0000 0000 |
		|  -1/512 x VREF | 01 1111 1111 | 11 1111 1111 |
		|-511/512 x VREF | 00 0000 0001 | 10 0000 0001 |
		|-512/512 x VREF | 00 0000 0000 | 10 0000 0000 |
		|----------------|--------------|--------------|

*******************************************************************************/

///*
module correlator_top #(parameter ADCbit = 10)(
input		clk_io,
input		greset_n_io,
input		[ADCbit-1:0] ADC_I_io,
input		[ADCbit-1:0] ADC_Q_io,
input		spidin_io,
input		spiload_io,
input		debug_in_io,
output wire [3:0] out_mux_io );

wire clk;
wire greset_n;
wire [ADCbit-1:0] ADC_I;
wire [ADCbit-1:0] ADC_Q;
wire spidin;
wire spiload;
wire debug_in;
wire [3:0] out_mux;

`define OUTPUT_PAD(name,pad,data) \
PDDW0204SCDG name \
(                 \
	.PAD (pad),   \
	.C   (),      \
	.I   (data),  \
	.DS  (1'b1),  \
	.OEN (1'b0),  \
	.PE  (1'b0),  \
	.IE  (1'b0)   \
);

`define INPUT_PAD(name,pad,data) \
PDDW0204SCDG name \
(                 \
	.PAD (pad),   \
	.C   (data),  \
	.I   (),      \
	.DS  (1'b0),  \
	.OEN (1'b1),  \
	.PE  (1'b0),  \
	.IE  (1'b1)   \
);
// defined w.r.t to correlator_top
//                Inst Name             PAD         data
`INPUT_PAD (        clk_pad,         clk_io,         clk )
`INPUT_PAD (   greset_n_pad,    greset_n_io,    greset_n )
`INPUT_PAD (     spidin_pad,      spidin_io,      spidin )
`INPUT_PAD (    spiload_pad,     spiload_io,     spiload )
`INPUT_PAD (   debug_in_pad,    debug_in_io,    debug_in )
`INPUT_PAD (    ADC_I_0_pad,    ADC_I_io[0],    ADC_I[0] )
`INPUT_PAD (    ADC_I_1_pad,    ADC_I_io[1],    ADC_I[1] )
`INPUT_PAD (    ADC_I_2_pad,    ADC_I_io[2],    ADC_I[2] )
`INPUT_PAD (    ADC_I_3_pad,    ADC_I_io[3],    ADC_I[3] )
`INPUT_PAD (    ADC_I_4_pad,    ADC_I_io[4],    ADC_I[4] )
`INPUT_PAD (    ADC_I_5_pad,    ADC_I_io[5],    ADC_I[5] )
`INPUT_PAD (    ADC_I_6_pad,    ADC_I_io[6],    ADC_I[6] )
`INPUT_PAD (    ADC_I_7_pad,    ADC_I_io[7],    ADC_I[7] )
`INPUT_PAD (    ADC_I_8_pad,    ADC_I_io[8],    ADC_I[8] )
`INPUT_PAD (    ADC_I_9_pad,    ADC_I_io[9],    ADC_I[9] )
`INPUT_PAD (    ADC_Q_0_pad,    ADC_Q_io[0],    ADC_Q[0] )
`INPUT_PAD (    ADC_Q_1_pad,    ADC_Q_io[1],    ADC_Q[1] )
`INPUT_PAD (    ADC_Q_2_pad,    ADC_Q_io[2],    ADC_Q[2] )
`INPUT_PAD (    ADC_Q_3_pad,    ADC_Q_io[3],    ADC_Q[3] )
`INPUT_PAD (    ADC_Q_4_pad,    ADC_Q_io[4],    ADC_Q[4] )
`INPUT_PAD (    ADC_Q_5_pad,    ADC_Q_io[5],    ADC_Q[5] )
`INPUT_PAD (    ADC_Q_6_pad,    ADC_Q_io[6],    ADC_Q[6] )
`INPUT_PAD (    ADC_Q_7_pad,    ADC_Q_io[7],    ADC_Q[7] )
`INPUT_PAD (    ADC_Q_8_pad,    ADC_Q_io[8],    ADC_Q[8] )
`INPUT_PAD (    ADC_Q_9_pad,    ADC_Q_io[9],    ADC_Q[9] )
`OUTPUT_PAD(  out_mux_0_pad,  out_mux_io[0],  out_mux[0] )
`OUTPUT_PAD(  out_mux_1_pad,  out_mux_io[1],  out_mux[1] )
`OUTPUT_PAD(  out_mux_2_pad,  out_mux_io[2],  out_mux[2] )
`OUTPUT_PAD(  out_mux_3_pad,  out_mux_io[3],  out_mux[3] )
//*/

/*
module correlator_top #(parameter ADCbit = 10)(
input		clk1,
input		clk2,
input		clkpco,
input		spiclk,
input		greset_n,
input		[ADCbit-1:0] ADC_I,
input		[ADCbit-1:0] ADC_Q,
input		spidin,
input		spiload,
input		debug_in,
output wire [3:0] out_mux );
*/

localparam SEQbit = 63;
localparam PRCNbit = 0;
localparam CNTRbit = 13;
localparam CONFIGbit = 23;

// SPI wires
wire [CONFIGbit-1:0] CONFIG;
wire [ADCbit-2:0] SCALE;
wire [ADCbit-1:0] THRESHOLD;
wire [ADCbit-1:0] OFFSET;
wire [0:SEQbit] ENCODED;
wire [0:SEQbit-1] DECODED;
wire [CNTRbit-1:0] NDELAY;
wire [CNTRbit-1:0] NBLACKOUT;
wire [CNTRbit-1:0] NCSTR;
wire [CNTRbit-1:0] NPCO;
wire [CNTRbit-1:0] NDUTYH;
wire [CNTRbit-1:0] NDUTYL;
wire [CNTRbit-1:0] NPULSE;
wire [CNTRbit-1:0] NDUTY;
// Configuration wires
wire [2:0] out_mux_sel0 = CONFIG[2:0];
wire [2:0] out_mux_sel1 = CONFIG[5:3];
wire [2:0] out_mux_sel2 = CONFIG[8:6];
wire [2:0] out_mux_sel3 = CONFIG[11:9];
wire spcore1_en;
wire spcore2_en;
wire pco_en;
wire pulsegen_en;
wire controller_en;
wire pco_design_sel;
wire peak_in_pco;
wire vpeak_block1;
wire vpeak_block2;
// Output mux and other wires
wire [CNTRbit-1:0] cntr_pco;
wire spidout;
wire pco_pulse_out;
wire pco_pulse_type;
wire duty_out;
wire pulsegen_out;
wire vpeak2;
wire vpeak1;
wire vpeak;
wire [2:0] state_ctrl;
wire [3:0] debug_pco; // trig_clk, cpulse, cntr_del[0], cntr_trig[0]
wire [3:0] debug_ctrl; // cntr2_rst, cntr1_rst, sync_slave, sync_lead


assign out_mux[0] =   ( out_mux_sel0 == 3'b000 ) ? vpeak
					: ( out_mux_sel0 == 3'b001 ) ? pco_pulse_out
					: ( out_mux_sel0 == 3'b010 ) ? debug_pco[0]
					: ( out_mux_sel0 == 3'b011 ) ? debug_ctrl[0]
					: ( out_mux_sel0 == 3'b100 ) ? state_ctrl[0]
					: ( out_mux_sel0 == 3'b101 ) ? duty_out // redundant
					: ( out_mux_sel0 == 3'b110 ) ? 1'b0
					:                              1'b1;
assign out_mux[1] =   ( out_mux_sel1 == 3'b000 ) ? vpeak1
					: ( out_mux_sel1 == 3'b001 ) ? pco_pulse_type
					: ( out_mux_sel1 == 3'b010 ) ? debug_pco[1]
					: ( out_mux_sel1 == 3'b011 ) ? debug_ctrl[1]
					: ( out_mux_sel1 == 3'b100 ) ? state_ctrl[1]
					: ( out_mux_sel1 == 3'b101 ) ? pulsegen_out // redundant
					: ( out_mux_sel1 == 3'b110 ) ? 1'b0
					:                              1'b1;
assign out_mux[2] =   ( out_mux_sel2 == 3'b000 ) ? vpeak2
					: ( out_mux_sel2 == 3'b001 ) ? duty_out
					: ( out_mux_sel2 == 3'b010 ) ? debug_pco[2]
					: ( out_mux_sel2 == 3'b011 ) ? debug_ctrl[2]
					: ( out_mux_sel2 == 3'b100 ) ? cntr_pco[0]
					: ( out_mux_sel2 == 3'b101 ) ? vpeak // redundant
					: ( out_mux_sel2 == 3'b110 ) ? 1'b0
					:                              1'b1;
assign out_mux[3] =   ( out_mux_sel3 == 3'b000 ) ? pulsegen_out
					: ( out_mux_sel3 == 3'b001 ) ? spidout
					: ( out_mux_sel3 == 3'b010 ) ? debug_pco[3]
					: ( out_mux_sel3 == 3'b011 ) ? debug_ctrl[3]
					: ( out_mux_sel3 == 3'b100 ) ? state_ctrl[2]
					: ( out_mux_sel3 == 3'b101 ) ? pco_pulse_out // redundant
					: ( out_mux_sel3 == 3'b110 ) ? 1'b0
					:                              1'b1;

assign vpeak = vpeak1 | vpeak2;
assign spcore1_en = CONFIG[13] ? ~duty_out : CONFIG[12];
assign spcore2_en = CONFIG[15] ? ~duty_out : CONFIG[14];
assign pco_en = CONFIG[16];
assign pulsegen_en = CONFIG[17];
assign controller_en = CONFIG[18];
assign pco_design_sel = CONFIG[19];
assign peak_in_pco = CONFIG[20] ? debug_in : vpeak;
assign vpeak_block1 = CONFIG[21];
assign vpeak_block2 = CONFIG[22];


spcore #(.SEQbit(SEQbit), .ADCbit(ADCbit), .PRCNbit(PRCNbit)) spcore1 (
.clk(clk),
.greset_n(greset_n),
.enable(spcore1_en),
.ADC_I(ADC_I),
.ADC_Q(ADC_Q),
.THRESHOLD(THRESHOLD),
.OFFSET(OFFSET),
.SCALE(SCALE),
.DECODED(DECODED),
.VPEAK_BLOCK(vpeak_block1),
.vpeak_in(vpeak2),
.vpeak_out(vpeak1) );


spcore #(.SEQbit(SEQbit), .ADCbit(ADCbit), .PRCNbit(PRCNbit)) spcore2 (
.clk(clk),
.greset_n(greset_n),
.enable(spcore2_en),
.ADC_I(ADC_I),
.ADC_Q(ADC_Q),
.THRESHOLD(THRESHOLD),
.OFFSET(OFFSET),
.SCALE(SCALE),
.DECODED(DECODED),
.VPEAK_BLOCK(vpeak_block2),
.vpeak_in(vpeak1),
.vpeak_out(vpeak2) );


pco #(.CNTRbit(CNTRbit)) pco1 (
.clk(clk),
.greset_n(greset_n),
.enable(pco_en),
.peak_in(peak_in_pco),
.PCODESIGNSEL(pco_design_sel),
.NDELAY(NDELAY),
.NBLACKOUT(NBLACKOUT),
.NCSTR(NCSTR),
.NPCO(NPCO),
.cntr_pco(cntr_pco),
.pco_pulse_out(pco_pulse_out),
.pco_pulse_type(pco_pulse_type),
.debug(debug_pco) );


pulsegen #(.SEQbit(SEQbit)) pulsegen1 (
.clk(clk),
.greset_n(greset_n),
.enable(pulsegen_en),
.trigger(pco_pulse_out),
.ENCODED(ENCODED),
.pulsegen_out(pulsegen_out) );


controller #(.CNTRbit(CNTRbit)) controller1 (
.clk(clk),
.greset_n(greset_n),
.enable(controller_en),
.pco_pulse_out(pco_pulse_out),
.pco_pulse_type(pco_pulse_type),
.cntr_pco(cntr_pco),
.NDUTYH(NDUTYH),
.NDUTYL(NDUTYL),
.NPULSE(NPULSE),
.NDUTY(NDUTY),
.duty_out(duty_out),
.state(state_ctrl),
.debug(debug_ctrl) );


spi #(.CONFIGbit(CONFIGbit), .SEQbit(SEQbit), .ADCbit(ADCbit), .PRCNbit(PRCNbit), .CNTRbit(CNTRbit)) spi1 (
.clk(clk),
//.greset_n(greset_n),
.din(spidin),
.load(spiload),
.dout(spidout),
.CONFIG(CONFIG),
.SCALE(SCALE),
.THRESHOLD(THRESHOLD),
.OFFSET(OFFSET),
.ENCODED(ENCODED),
.DECODED(DECODED),
.NDELAY(NDELAY),
.NBLACKOUT(NBLACKOUT),
.NCSTR(NCSTR),
.NPCO(NPCO),
.NDUTYH(NDUTYH),
.NDUTYL(NDUTYL),
.NPULSE(NPULSE),
.NDUTY(NDUTY) );


endmodule // module correlator_top

/*******************************************************************************

	Written by Ivan Bukreyev
	Last modified on 3/25/2018
	Differential detector for BPSK encoding
	Ideal operation: decodedIQ = I[n]*I[n-1] + Q[n]*Q[n-1]
	Actual operation: decodedIQ = I[n]*sign(I[n-1]) + Q[n]*sign(Q[n-1])
		sign = 0 -> sign extend
		sign = 1 -> sign extend and take two's complement
	inputI/inputQ format: (ADCbit)-bit two's complement
	decodedIQ format: (ADCbit+1)-bit two's complement
	Output is extended by 1 bit just in case
		If I/Q are both at max ADC amplitude, (unlikely) overflow could occur

*******************************************************************************/

module diffdet #(parameter ADCbit = 10)(
input		clk,
input		greset_n,
input		enable,
input		[ADCbit-1:0] inputI,
input		[ADCbit-1:0] inputQ,
output wire	[ADCbit:0] decodedIQ );


wire [ADCbit:0] inputI_ext;
wire [ADCbit:0] inputQ_ext;
wire [ADCbit:0] inputI_ext_2scomp;
wire [ADCbit:0] inputQ_ext_2scomp;
wire [ADCbit:0] tempI;
wire [ADCbit:0] tempQ;
reg signI;
reg signQ;


always @(posedge clk) begin
	if (~greset_n) begin
		signI <= 1'b0;
		signQ <= 1'b0;
	end else if (enable) begin
		signI <= inputI[ADCbit-1]; // save sign(I[n-1])
		signQ <= inputQ[ADCbit-1]; // save sign(Q[n-1])
	end
end

// sign extend
assign inputI_ext = {inputI[ADCbit-1], inputI};
assign inputQ_ext = {inputQ[ADCbit-1], inputQ};
assign inputI_ext_2scomp = ~inputI_ext + 1'b1;
assign inputQ_ext_2scomp = ~inputQ_ext + 1'b1;

// if negative (sign == 1) , invert
assign tempI = (~signI) ? inputI_ext : inputI_ext_2scomp;
assign tempQ = (~signQ) ? inputQ_ext : inputQ_ext_2scomp;

assign decodedIQ = tempI + tempQ;


endmodule // module diffdet

/*******************************************************************************

	Written by Ivan Bukreyev
	Last modified on 3/19/2018
	Implements a PCO module with progressively-slowing counter architecture
	PCO period = T_clk*[NDELAY + NPCO*(NPCO-1)/2]
		(NPCO-1) since cntr_pco counter starts at 1
	NBLACKOUT: blocks cpulse generation
	NCSTR: specifies coupling strength
	PCODESIGNSEL: selects cntr_del reset value, see doi:10.1109/ISCAS.2015.7168883 for more info
	pco_pulse_out: (combinational) PCO coupling pulse
	pco_pulse_type: (combinational) is 1 if pco_pulse_out was due to peak_in, otherwise 0
	cpulse generation latency is ~= 2 clock cycles after peak_in is true
	cntr_trig_en: enables generation of trigger clock after initial delay period
	trig_clk: progressively-slowing trigger clock
	cntr_pco_rst: PCO reset signal

*******************************************************************************/

module pco #(parameter CNTRbit = 13)(
input		clk,
input		greset_n,
input		enable,
input		peak_in,
input		PCODESIGNSEL,
input		[CNTRbit-1:0] NDELAY,
input		[CNTRbit-1:0] NBLACKOUT,
input		[CNTRbit-1:0] NCSTR,
input		[CNTRbit-1:0] NPCO,
output reg	[CNTRbit-1:0] cntr_pco,
output wire	pco_pulse_out,
output wire	pco_pulse_type,
output wire	[3:0] debug );


localparam zeros = {(CNTRbit){1'b0}};
localparam one = {{(CNTRbit-1){1'b0}}, 1'b1};


reg [CNTRbit-1:0] cntr_del;
reg [CNTRbit-1:0] cntr_trig;
wire cntr_trig_en;
wire cntr_pco_rst;
wire trig_clk;
reg [2:0] cpulse_sync;
wire cpulse;
wire cpulse_will_reset;
wire trig_clk_will_reset;


assign pco_pulse_out = cntr_pco_rst;
assign pco_pulse_type = cpulse && cpulse_will_reset;
assign debug = {trig_clk, cpulse, cntr_del[0], cntr_trig[0]};

// Generate internal signals
assign cpulse = !cpulse_sync[2] && cpulse_sync[1] && (cntr_pco > NBLACKOUT);
assign cntr_trig_en = (cntr_del == NDELAY);
assign trig_clk = ((cntr_trig + 1'b1) == cntr_pco) && cntr_trig_en;
assign cpulse_will_reset = ({1'b0, cntr_pco} + {1'b0, NCSTR}) >= {1'b0, NPCO}; // ((cntr_pco + NCSTR) >= NPCO)
assign trig_clk_will_reset = (cntr_pco + 1'b1) == NPCO;
assign cntr_pco_rst = (cpulse && cpulse_will_reset) || (trig_clk && trig_clk_will_reset);

// Synchronize peak_in to local clock (2 flops) and store previous sample
always @(posedge clk) begin
	if (~greset_n) begin
		cpulse_sync[0] <= 1'b0;
		cpulse_sync[1] <= 1'b0;
		cpulse_sync[2] <= 1'b0;
	end else if (enable) begin
		cpulse_sync[0] <= peak_in;
		cpulse_sync[1] <= cpulse_sync[0];
		cpulse_sync[2] <= cpulse_sync[1];
	end
end

// Delay Counter
always @(posedge clk) begin
	if (~greset_n || cntr_pco_rst) begin
		if (PCODESIGNSEL && pco_pulse_type) begin
			cntr_del <= one;
		end else begin
			cntr_del <= zeros;
		end
	end else if (enable) begin
		if (cntr_del != NDELAY) begin
			cntr_del <= cntr_del + 1'b1;
		end
	end
end

// Trigger Counter
always @(posedge clk) begin
	if (~greset_n || cntr_pco_rst) begin
		cntr_trig <= zeros;
	end else if (enable) begin
		if ((cntr_trig + 1'b1) == cntr_pco) begin
			cntr_trig <= zeros;
		end else begin
			cntr_trig <= cntr_trig + 1'b1;
		end
	end
end

// PCO Counter
always @(posedge clk) begin
	if (~greset_n) begin
		cntr_pco <= one;
//		pco_pulse_out <= 1'b0;
//		pco_pulse_type <= 1'b0;
	end else if (enable) begin
		if (cpulse) begin
			if (cpulse_will_reset) begin // threshold reached with cpulse
//				pco_pulse_out <= 1'b1;
//				pco_pulse_type <= 1'b1;
				cntr_pco <= one;
			end else begin
				cntr_pco <= cntr_pco + NCSTR;
			end
		end else if (trig_clk) begin
			if (trig_clk_will_reset) begin // threshold reached by overflow
//				pco_pulse_out <= 1'b1;
//				pco_pulse_type <= 1'b0;
				cntr_pco <= one;
			end else begin
				cntr_pco <= cntr_pco + 1'b1;
			end	
//		end else begin
//			pco_pulse_out <= 1'b0;
//			pco_pulse_type <= 1'b0;
		end
	end
end


endmodule // module pco

/*******************************************************************************

	Written by Ivan Bukreyev
	Last modified on 3/25/2018
	Implements a pseudo-multiplier of a signal processing core
	PRCNbit specifies how many bits (to the right) to add for multiplication precision
	unscaled_in format: (WIDTH)-bit two's complement
	scaled_out format: (WIDTH+PRCNbit)-bit two's complement
		WIDTH should be greater or equal to (ADCbit+1)
	Pseudo multiplier performs the following scaling: scaled_out = alpha*unscaled_in
	SCALE is (ADCbit-1)-bit signal that configures alpha to be between 0 and 1
		e.g. SCALE = "010001100" sets alpha = (1/8 + 1/16 + 1/256)
	sum/unscaled/scaled are the same size since alpha never exceeds 1
	Pseudo-multiplication is accomplished by shifting to the right, so (PRCNbit > 0) effectively makes shifted bits significant
		e.g. if PRCNbit = 0: 7*2^0/4 => SHIFT_RIGHT("0111",2) = "0001" = 1
		e.g. if PRCNbit = 4: 7*2^4/4 => SHIFT_RIGHT("01110000",2) = "00011100" = 28
	PRCNbit increases the size of the signal chain down the line in order to keep precision

*******************************************************************************/

module pseudomult #(parameter WIDTH = 11, parameter ADCbit = 10, parameter PRCNbit = 0)(
input		[WIDTH-1:0] unscaled_in,
input		[ADCbit-2:0] SCALE,
output wire	[WIDTH-1+PRCNbit:0] scaled_out );


localparam sum_zeros = {(WIDTH+PRCNbit){1'b0}};
localparam add_lvls = $clog2(ADCbit-1); // depends on the size of SCALE


reg signed [WIDTH-1+PRCNbit:0] sum [0:add_lvls][0:(2**add_lvls)-1];
wire signed [WIDTH-1+PRCNbit:0] unscaled; // without signed keyword, adder tree does not work properly
wire signed [WIDTH-1+PRCNbit:0] scaled;
integer ii;
integer jj;


assign unscaled = {unscaled_in, {PRCNbit{1'b0}}}; // zero-pad unscaled_in from the right (i.e. multiply by 2^PRCNbit-1)
assign scaled = sum[add_lvls][0];
assign scaled_out = $unsigned(scaled); // for signed vs. unsigned consistency

// Input scaling with an adder tree
always @(*) begin
	for (ii = 1; ii <= (2 ** add_lvls); ii = ii + 1) begin
		if ( (ii - 1) < (ADCbit - 1) ) begin
			if (SCALE[ii-1]) begin
				sum[0][ii-1] = unscaled >>> ii;
			end else begin
				sum[0][ii-1] = sum_zeros;
			end
		end else begin
			sum[0][ii-1] = sum_zeros; // initialize the rest with zeros (should optimize away)
		end
	end

	for (jj = 0; jj < add_lvls; jj = jj + 1) begin // generate adder tree
		for (ii = 0; ii < (2 ** (add_lvls - 1 - jj) ); ii = ii + 1 ) begin
			sum[jj+1][ii] = sum[jj][2*ii] + sum[jj][2*ii+1];
		end
	end
end


endmodule // module pseudomult

/*******************************************************************************

	Written by Ivan Bukreyev
	Last modified on 3/19/2018
	Implements a digital output driver for the coupling sequence
	Output sequence is encoded, therefore it has SEQbit+1 bits
	sel_first/sel_last point to the first/last bits of ENCODED
	!!!!! add two sequences in a row !!!!!

*******************************************************************************/

module pulsegen #(parameter SEQbit = 63)(
input		clk,
input		greset_n,
input		enable,
input		trigger,
input		[0:SEQbit] ENCODED,
output wire	pulsegen_out );


localparam cntr_size = $clog2(SEQbit+1);
localparam [cntr_size-1:0] sel_first = {(cntr_size){1'b0}};
localparam [cntr_size-1:0] sel_last = SEQbit; // Warning: truncated bits !!


reg [cntr_size-1:0] cntr;


assign pulsegen_out = ENCODED[cntr];

always @(posedge clk) begin // synchronous trigger, hold last
	if (~greset_n) begin
		cntr <= sel_last;
	end else if (enable) begin
		if (trigger && (cntr == sel_last)) begin
			cntr <= sel_first;
		end else if (cntr < sel_last)  begin // could use !=
			cntr <= cntr + 1'b1;
		end
	end
end


endmodule // module pulsegen

/*******************************************************************************

	Written by Ivan Bukreyev
	Last modified on 3/25/2018
	Implements a slice of a signal processing core
	sample_in/sample_in_mag/sample_del/slice_out format: (ADCbit+1)-bit two's complement
		width is incremented by 1 in the differential detector
	sample_in_mag is the magnitude of the sample_in
	sample_del is delayed version of sample_in for the next slice
	slice_out is the output of the slice for correlation
	
	slice_out logic:
	|  select  |  sign(r[n])  | seq_bit[n]  | slice_out   |
	|----------|--------------|-------------|-------------|
	|    1     |     + (0)    |    - (0)    | - sample_in |
	|    1     |     + (0)    |    + (1)    | + sample_in |
	|    1     |     - (1)    |    - (0)    | - sample_in |
	|    1     |     - (1)    |    + (1)    | + sample_in |
	|    0     |       X      |      X      |    zeros    |
	|----------|--------------|-------------|-------------|

*******************************************************************************/

module spcore_slice #(parameter ADCbit = 10)(
input		clk,
input		greset_n,
input		enable,
input		select,
input		seq_bit,
input		[ADCbit:0] sample_in,
output wire	[ADCbit:0] sample_in_mag,
output reg	[ADCbit:0] sample_del,
output wire	[ADCbit:0] slice_out );


localparam zeros = {(ADCbit+1){1'b0}};


wire sign;
wire [ADCbit:0] sample_in_2scomp;


assign sign = sample_in[ADCbit];
assign sample_in_2scomp = ~sample_in + 1'b1;
// Output to correlation
assign sample_in_mag = ({select, sign} == 2'b10) ? sample_in
                     : ({select, sign} == 2'b11) ? sample_in_2scomp
                     : zeros;
// Output to correlation
assign slice_out = ({select, sign, seq_bit} == 3'b100) ? sample_in_2scomp
                 : ({select, sign, seq_bit} == 3'b101) ? sample_in
                 : ({select, sign, seq_bit} == 3'b110) ? sample_in_2scomp
                 : ({select, sign, seq_bit} == 3'b111) ? sample_in
                 : zeros;
// Delay element
always @(posedge clk) begin
	if (~greset_n) begin
		sample_del <= zeros;
	end else if (enable) begin
		sample_del <= sample_in;
	end
end


endmodule // module spcore_slice

/*******************************************************************************

	Written by Ivan Bukreyev
	Last modified on 3/26/2018
	Implements a signal processing core of the ASP (see 2018 RFIC paper equations 3 - 6)
	enable is used for clock-gating the signal processing core
	rn is a vector of decoded and stored inputs
	rn_abs is the absolute value sum of all samples (rn_mag) of the decoded signal
	vcorrn is a vector of spcore_slice's outputs
	vcorrn_ave is a direct sum of all spcore_slice's outputs
	vpeak_in (or vpeak_out from the other core) blocks this core's output so that combined vpeak_out's width is constant
	VPEAK_BLOCK controls whether this core's output is blocked by the other core

*******************************************************************************/

module spcore #(parameter SEQbit = 63, parameter ADCbit = 10, parameter PRCNbit = 0)(
input		clk,
input		greset_n,
input		enable,
input		[ADCbit-1:0] ADC_I,
input		[ADCbit-1:0] ADC_Q,
input		[ADCbit-1:0] THRESHOLD,
input		[ADCbit-1:0] OFFSET,
input		[ADCbit-2:0] SCALE,
input		[0:SEQbit-1] DECODED,
input		VPEAK_BLOCK,
input		vpeak_in,
output reg	vpeak_out );


localparam add_lvls = $clog2(SEQbit);
localparam sum_zeros = {(add_lvls+ADCbit+1){1'b0}};
localparam [$clog2(SEQbit)-1:0] SLICESEL = 6'b111111;


reg [ADCbit-1:0] inputI;
reg [ADCbit-1:0] inputQ;
wire [0:SEQbit-1] slice_select;
wire [ADCbit:0] rn [0:SEQbit-1];
wire [ADCbit:0] rn_mag [0:SEQbit-1];
wire [ADCbit:0] vcorrn [0:SEQbit-1];
reg signed [add_lvls+ADCbit:0] sum1 [0:add_lvls][0:(2**add_lvls)-1];
reg signed [add_lvls+ADCbit:0] sum2 [0:add_lvls][0:(2**add_lvls)-1];
wire [add_lvls+ADCbit:0] vcorrn_ave;
wire [add_lvls+ADCbit:0] rn_abs;
wire [add_lvls+ADCbit+PRCNbit:0] rn_abs_scaled;
//wire [ADCbit:0] vcorrn_ave;
//wire [ADCbit:0] rn_abs;
//wire [ADCbit+PRCNbit:0] rn_abs_scaled;
genvar kk;
integer ii;
integer jj;

// resize final sums to smaller size while keeping msb (ex: 6 bit 1_11_001 to 4 bit 1__001)
//assign vcorrn_ave = {sum1[add_lvls][0][add_lvls+ADCbit], sum1[add_lvls][0][ADCbit-1:0]};
//assign rn_abs = {sum2[add_lvls][0][add_lvls+ADCbit], sum2[add_lvls][0][ADCbit-1:0]};
assign vcorrn_ave = $unsigned(sum1[add_lvls][0]);
assign rn_abs = $unsigned(sum2[add_lvls][0]);


always @(posedge clk) begin
	if (~greset_n) begin
		inputI <= {ADCbit{1'b0}};
		inputQ <= {ADCbit{1'b0}};
	end else if (enable) begin
		inputI <= ADC_I;
		inputQ <= ADC_Q;
	end
end


diffdet #(.ADCbit(ADCbit)) differential_detector (
	.clk(clk),
	.greset_n(greset_n),
	.enable(enable),
	.inputI(inputI),
	.inputQ(inputQ),
	.decodedIQ(rn[0])
);	

// instantiate and connect all slices
generate
	for (kk = 0; kk < SEQbit; kk = kk + 1) begin : generate_spcore_slices
		assign slice_select[kk] = (SLICESEL >= kk) ? 1'b1 : 1'b0; // thermometer decoder, 0th is always enabled
		if (kk == (SEQbit - 1)) begin // do not need last sample_del
			spcore_slice #(.ADCbit(ADCbit)) array_of_spcore_slice (
			.clk(clk),
			.greset_n(greset_n),
			.enable(enable),
			.select(slice_select[kk]),
			.seq_bit(DECODED[kk]),
			.sample_in(rn[kk]),
			.sample_in_mag(rn_mag[kk]),
			.slice_out(vcorrn[kk]) );
		end else begin
			spcore_slice #(.ADCbit(ADCbit)) array_of_spcore_slice (
			.clk(clk),
			.greset_n(greset_n),
			.enable(enable),
			.select(slice_select[kk]),
			.seq_bit(DECODED[kk]),
			.sample_in(rn[kk]),
			.sample_in_mag(rn_mag[kk]),
			.sample_del(rn[kk+1]),
			.slice_out(vcorrn[kk]) );
		end
	end
endgenerate

// adder tree for vcorrn_ave
always @(*) begin
	for (ii = 0; ii < (2 ** add_lvls); ii = ii + 1) begin
		if ( ii < SEQbit ) begin
			sum1[0][ii] = $signed(vcorrn[ii]); // sign extend
		end else begin
			sum1[0][ii] = sum_zeros; // initialize the rest with zeros (should optimize away)
		end
	end

	for (jj = 0; jj < add_lvls; jj = jj + 1) begin // generate adder tree
		for (ii = 0; ii < (2 ** (add_lvls - 1 - jj) ); ii = ii + 1 ) begin
			sum1[jj+1][ii] = sum1[jj][2*ii] + sum1[jj][2*ii+1];
		end
	end
end

// adder tree for rn_abs
always @(*) begin
	for (ii = 0; ii < (2 ** add_lvls); ii = ii + 1) begin
		if ( ii < SEQbit ) begin
			sum2[0][ii] = $signed(rn_mag[ii]); // sign extend
		end else begin
			sum2[0][ii] = sum_zeros; // initialize the rest with zeros (should optimize away)
		end
	end

	for (jj = 0; jj < add_lvls; jj = jj + 1) begin // generate adder tree
		for (ii = 0; ii < (2 ** (add_lvls - 1 - jj) ); ii = ii + 1 ) begin
			sum2[jj+1][ii] = sum2[jj][2*ii] + sum2[jj][2*ii+1];
		end
	end
end


pseudomult #(.WIDTH(add_lvls+ADCbit+1), .ADCbit(ADCbit), .PRCNbit(PRCNbit)) pseudo_multiplier (
	.unscaled_in(rn_abs),
	.SCALE(SCALE),
	.scaled_out(rn_abs_scaled)
);


always @(posedge clk) begin
	if (~greset_n || (vpeak_in && VPEAK_BLOCK)) begin
		vpeak_out <= 1'b0;
	end else if (enable) begin
		if ($signed(vcorrn_ave) >= ($signed(rn_abs_scaled) + $signed(OFFSET))) begin
		//if ($signed(sum1[add_lvls][0]) >= $signed(sum2[add_lvls][0])) begin
			vpeak_out <= 1'b1;
		end else begin
			vpeak_out <= 1'b0;
		end
	end
end


endmodule // module spcore

/*******************************************************************************

	Written by Ivan Bukreyev
	Last modified on 3/26/2018
	SPI module that provides all parameters to the correlator modules
	SPI holds the following values
		(CNTRbit*4) for the PCO's counters/comparators
		(CNTRbit*4) for the controller's counters/comparators
		(SEQbit) for correlator depth (DECODED)
		(SEQbit+1) for pulsegen (ENCODED)
		(ADCbit*2) for correlator's THRESHOLD and OFFSET
		(ADCbit-1) for pseudo-multiplier (SCALE)
		(CONFIGbit) for all other configurations, enables, muxes, bypasses, etc.
	CONFIG order (from low to high, then msb to lsb)
		1) out_mux[3:0] selects, 4 x 3 bits
		2) duty-cycle route and enable for spcore1 and spcore2, 4 bits
		3) other module enable signals, 3 bits
		4) pco design select, 1 bit
		5) debug input function, 1 bit

	Notes:
		64'hB667432208B96DA2; // 64-bit encoded kasami
		64'h45B69D1044C2E66D; // 64-bit encoded kasami, flipped
		63'h12AB1D4CF31A248C; // 63-bit decoded kasami
		63'h18922C67995C6AA4; // 63-bit decoded kasami, flipped

*******************************************************************************/

module spi #(parameter CONFIGbit = 1, parameter SEQbit = 1, parameter ADCbit = 1, parameter PRCNbit = 1, parameter CNTRbit = 1)(
input		clk,
//input		greset_n,
input		din,
input		load,
output wire	dout,
output wire [CONFIGbit-1:0] CONFIG,
output wire [ADCbit-2:0] SCALE,
output wire [ADCbit-1:0] THRESHOLD,
output wire [ADCbit-1:0] OFFSET,
output wire [0:SEQbit] ENCODED,
output wire [0:SEQbit-1] DECODED,
output wire [CNTRbit-1:0] NDELAY,
output wire [CNTRbit-1:0] NBLACKOUT,
output wire [CNTRbit-1:0] NCSTR,
output wire [CNTRbit-1:0] NPCO,
output wire [CNTRbit-1:0] NDUTYH,
output wire [CNTRbit-1:0] NDUTYL,
output wire [CNTRbit-1:0] NPULSE,
output wire [CNTRbit-1:0] NDUTY );


localparam SPIwidth = (CONFIGbit) + (3*ADCbit-1) + (2*SEQbit+1) + (CNTRbit*8);


reg [SPIwidth-1:0] shadow_reg;
reg [SPIwidth-1:0] active_reg;
integer ii;


always @(posedge clk) begin // no reset
	shadow_reg[0] <= din;
	for (ii = 0; ii < SPIwidth - 1; ii = ii + 1) begin
		shadow_reg[ii+1] <= shadow_reg[ii];
	end
end

assign dout = shadow_reg[SPIwidth-1];

always @(posedge load) begin // no reset
	for (ii = 0; ii < SPIwidth; ii = ii + 1) begin
		active_reg[ii] <= shadow_reg[ii];
	end
end

assign CONFIG = active_reg[SPIwidth-1:CNTRbit*8+2*SEQbit+1+3*ADCbit-1]; // width = CONFIGbit
assign SCALE = active_reg[CNTRbit*8+2*SEQbit+1+3*ADCbit-2:CNTRbit*8+2*SEQbit+1+2*ADCbit]; // width = ADCbit-1
assign THRESHOLD = active_reg[CNTRbit*8+2*SEQbit+1+2*ADCbit-1:CNTRbit*8+2*SEQbit+1+ADCbit]; // width = ADCbit
assign OFFSET = active_reg[CNTRbit*8+2*SEQbit+1+ADCbit-1:CNTRbit*8+2*SEQbit+1]; // width = ADCbit
assign ENCODED = active_reg[CNTRbit*8+2*SEQbit:CNTRbit*8+SEQbit]; // width = SEQbit+1
assign DECODED = active_reg[CNTRbit*8+SEQbit-1:CNTRbit*8]; // width = SEQbit
assign NDELAY = active_reg[CNTRbit*8-1:CNTRbit*7]; // width = CNTRbit
assign NBLACKOUT = active_reg[CNTRbit*7-1:CNTRbit*6]; // width = CNTRbit
assign NCSTR = active_reg[CNTRbit*6-1:CNTRbit*5]; // width = CNTRbit
assign NPCO = active_reg[CNTRbit*5-1:CNTRbit*4]; // width = CNTRbit
assign NDUTYH = active_reg[CNTRbit*4-1:CNTRbit*3]; // width = CNTRbit
assign NDUTYL = active_reg[CNTRbit*3-1:CNTRbit*2]; // width = CNTRbit
assign NPULSE = active_reg[CNTRbit*2-1:CNTRbit]; // width = CNTRbit
assign NDUTY = active_reg[CNTRbit-1:0]; // width = CNTRbit

//assign CONFIG = {2'b00, 1'b0, 1'b0, 3'b111, 4'b0101, 3'b101, 3'b000, 3'b000, 3'b000};
//assign SCALE = 9'b100001101; // alpha = 0.69: 9'b100001101; alpha_p for alpha = 0.69: 9'b011110100
//assign THRESHOLD = 10'd0;
//assign OFFSET = 10'd0;
//assign ENCODED = 64'hB667432208B96DA2;
//assign DECODED = 63'h12AB1D4CF31A248C;
//assign NDELAY = 13'd660;
//assign NBLACKOUT = 13'd198;
//assign NCSTR = 13'd300;
//assign NPCO = 13'd281;
//assign NDUTYH = 13'd191;
//assign NDUTYL = 13'd10;
//assign NPULSE = 13'd5;
//assign NDUTY = 13'd10;


endmodule // module spi

