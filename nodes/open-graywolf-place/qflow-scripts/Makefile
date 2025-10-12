default: vlog2Verilog vlog2Cel

CFLAGS = -g -O2

HASHLIB = hash.o
LEFLIB = readlef.o
VERILOGLIB = readverilog.o

vlog2Verilog: vlog2Verilog.o $(HASHLIB) $(LEFLIB) $(VERILOGLIB)
	$(CC) $(LDFLAGS) vlog2Verilog.o $(HASHLIB) $(VERILOGLIB) $(LEFLIB) \
		-o $@ $(LIBS)

vlog2Cel: vlog2Cel.o $(HASHLIB) $(LEFLIB) $(VERILOGLIB)
	$(CC) $(LDFLAGS) vlog2Cel.o $(HASHLIB) $(VERILOGLIB) $(LEFLIB) \
		-o $@ $(LIBS)

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) $(DEFS) -c $< -o $@

clean:
	rm -f *.o vlog2Cel vlog2Verilog

