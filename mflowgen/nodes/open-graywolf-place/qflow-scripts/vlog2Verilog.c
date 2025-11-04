//----------------------------------------------------------------
// vlog2Verilog
//----------------------------------------------------------------
// Convert between verilog styles.
// Options include bit-blasting vectors and adding power
// supply connections.
//
// Revision 0, 2018-11-29: First release by R. Timothy Edwards.
//
// This program is written in ISO C99.

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>	/* For getopt() */
#include <math.h>
#include <ctype.h>
#include <float.h>

#include "hash.h"
#include "readverilog.h"
#include "readlef.h"

int write_output(struct cellrec *, unsigned char, char *);
void helpmessage(FILE *outf);
void cleanup_string(char *);

char *VddNet = NULL;
char *GndNet = NULL;
char *AntennaCell = NULL;

struct hashtable Lefhash;

/* Define option flags */

#define	IMPLICIT_POWER	(unsigned char)0x01
#define	MAINTAIN_CASE	(unsigned char)0x02
#define	BIT_BLAST	(unsigned char)0x04
#define	NONAME_POWER	(unsigned char)0x08
#define ADD_ANTENNA	(unsigned char)0x10

/*--------------------------------------------------------------*/

int main (int argc, char *argv[])
{
    int i, result;
    unsigned char Flags;

    char *vloginname = NULL;
    char *vlogoutname = NULL;
    struct cellrec *topcell;

    Flags = (unsigned char)IMPLICIT_POWER;

    VddNet = strdup("VDD");
    GndNet = strdup("VSS");

    InitializeHashTable(&Lefhash, SMALLHASHSIZE);

    while ((i = getopt(argc, argv, "pbchnHv:g:l:o:a:")) != EOF) {
	switch( i ) {
	    case 'p':
		Flags &= ~IMPLICIT_POWER;
		break;
	    case 'b':
		Flags |= BIT_BLAST;
		break;
	    case 'c':
		Flags |= MAINTAIN_CASE;
		break;
	    case 'a':
		Flags |= ADD_ANTENNA;
		if (AntennaCell != NULL) free(AntennaCell);
		AntennaCell = strdup(optarg);
		break;
	    case 'n':
		Flags |= NONAME_POWER;
		break;
	    case 'h':
	    case 'H':
		helpmessage(stdout);
		exit(0);
		break;
	    case 'l':
		LefRead(optarg);		/* Can be called multiple times */
		break;
	    case 'v':
		free(VddNet);
		VddNet = strdup(optarg);
		cleanup_string(VddNet);
		break;
	    case 'o':
		vlogoutname = strdup(optarg);
		break;
	    case 'g':
		free(GndNet);
		GndNet = strdup(optarg);
		cleanup_string(GndNet);
		break;
	    default:
		fprintf(stderr,"Bad switch \"%c\"\n", (char)i);
		helpmessage(stderr);
		return 1;
	}
    }

    if (optind < argc) {
	vloginname = strdup(argv[optind]);
	optind++;
    }
    else {
	fprintf(stderr, "Couldn't find a filename as input\n");
	helpmessage(stderr);
	return 1;
    }
    optind++;

    /* If any LEF files were read, hash the GateInfo list */
    if (GateInfo != NULL) {
	GATE gate;
	for (gate = GateInfo; gate; gate = gate->next) {
	    HashPtrInstall(gate->gatename, gate, &Lefhash);
	}
    }

    topcell = ReadVerilog(vloginname);
    result = write_output(topcell, Flags, vlogoutname);
    return result;
}

/*--------------------------------------------------------------*/
/* String input cleanup	(mainly strip quoted text)		*/
/*--------------------------------------------------------------*/

void cleanup_string(char *text)
{
    int i;
    char *sptr, *wptr;

    /* Remove quotes from quoted strings */

    sptr = strchr(text, '"');
    if (sptr != NULL) {
       i = 0;
       while (sptr[i + 1] != '"') {
          sptr[i] = sptr[i + 1];
          i++;
       }
       sptr[i] = '\0';
    }
}

/*--------------------------------------------------------------------------*/
/* Recursion callback function for each item in the cellrec nets hash table */
/*--------------------------------------------------------------------------*/

struct nlist *output_wires(struct hashlist *p, void *cptr)
{
    struct netrec *net;
    FILE *outf = (FILE *)cptr;

    net = (struct netrec *)(p->ptr);

    /* Ignore the power and ground nets;  these have already been output */
    /* This also extends to any net in the form <digit><single quote>	 */

    if (p->name[0] == '\'') return NULL;
    if (isdigit(p->name[0])) {
	char c, *dptr;

	dptr = p->name;
	while (isdigit(*dptr)) dptr++;
	if (*dptr == '\0') return NULL;
	else if (*dptr == '\'') {
	    c = *(dptr + 1);
	    if (c == 'b' || c == 'h' || c == 'd' || c == 'o')
		return NULL;
	}
    }

    fprintf(outf, "wire ");
    if (net->start >= 0 && net->end >= 0) {
	fprintf(outf, "[%d:%d] ", net->start, net->end);
    }
    fprintf(outf, "%s ;\n", p->name);
    return NULL;
}

/*----------------------------------------------------------------------*/
/* Convert a verilog number into a binary string.  The target string 	*/
/* "bitstring" is assumed to be at least (bits + 1) bytes in length.	*/
/* "c" is a conversion type ('h', 'o', or 'd').				*/
/*----------------------------------------------------------------------*/
/* hexidecimal to binary */

char *hex2binary(char *uval, int bits)
{
    int first, dval, hexc;
    char *bitstring = (char *)malloc(1 + bits);
    char *hptr, *bptr, *hstring;
    char binhex[5];

    first = bits % 4;
    hexc = ((first == 0) ? 0 : 1) + (bits / 4);	    /* Number of hex characters */

    hstring = (char *)malloc(hexc + 1);
    strncpy(hstring, uval, hexc);
    *(hstring + hexc) = '\0';
    for (hptr = hstring; *hptr != '\0'; hptr++) {

	/* Catch 'x', 'X', etc., and convert to zero.	*/
	/* Keep 'z'/'Z' as this must be handled differently	*/

	if ((*hptr == 'z') || (*hptr == 'Z')) *hptr = 'Z';
	else if ((*hptr == 'x') || (*hptr == 'X')) *hptr = '0';
    }
    
    hptr = hstring;
    bptr = bitstring;
    while (*hptr != '\0') {
	switch(*hptr) {
	    case 'Z':
		strcpy(binhex, "ZZZZ");
		break;
	    case '0':
		strcpy(binhex, "0000");
		break;
	    case '1':
		strcpy(binhex, "0001");
		break;
	    case '2':
		strcpy(binhex, "0010");
		break;
	    case '3':
		strcpy(binhex, "0011");
		break;
	    case '4':
		strcpy(binhex, "0100");
		break;
	    case '5':
		strcpy(binhex, "0101");
		break;
	    case '6':
		strcpy(binhex, "0110");
		break;
	    case '7':
		strcpy(binhex, "0111");
		break;
	    case '8':
		strcpy(binhex, "1000");
		break;
	    case '9':
		strcpy(binhex, "1001");
		break;
	    case 'a':
		strcpy(binhex, "1010");
		break;
	    case 'b':
		strcpy(binhex, "1011");
		break;
	    case 'c':
		strcpy(binhex, "1100");
		break;
	    case 'd':
		strcpy(binhex, "1101");
		break;
	    case 'e':
		strcpy(binhex, "1110");
		break;
	    case 'f':
		strcpy(binhex, "1111");
		break;
	}
	if (first > 0) {
	    strncpy(bptr, binhex + (4 - first), first);
            *(bptr + first) = '\0';
	    bptr += first;
	    first = 0;
	}
	else {
	    strcpy(bptr, binhex);
	    bptr += 4;
	}
	hptr++;
    }
    return bitstring;
}

/* octal to binary */

char *oct2binary(char *uval, int bits)
{
    int first, dval, octc;
    char *bitstring = (char *)malloc(1 + bits);
    char *optr, *bptr, *ostring;
    char binoct[4];

    first = bits % 3;
    octc = ((first == 0) ? 0 : 1) + (bits / 3);	/* Number of octal characters */
    ostring = (char *)malloc(1 + octc);

    ostring = (char *)malloc(octc + 1);
    strncpy(ostring, uval, octc);
    *(ostring + octc) = '\0';
    for (optr = ostring; *optr != '\0'; optr++) {

	/* Catch 'x', 'X', etc., and convert to zero.	*/
	/* Keep 'z'/'Z' as this must be handled differently	*/

	if ((*optr == 'z') || (*optr == 'Z')) *optr = 'Z';
	else if ((*optr == 'x') || (*optr == 'X')) *optr = '0';
    }
    
    optr = ostring;
    bptr = bitstring;
    while (*optr != '\0') {
	switch(*optr) {
	    case 'Z':
		strcpy(binoct, "ZZZ");
		break;
	    case '0':
		strcpy(binoct, "000");
		break;
	    case '1':
		strcpy(binoct, "001");
		break;
	    case '2':
		strcpy(binoct, "010");
		break;
	    case '3':
		strcpy(binoct, "011");
		break;
	    case '4':
		strcpy(binoct, "100");
		break;
	    case '5':
		strcpy(binoct, "101");
		break;
	    case '6':
		strcpy(binoct, "110");
		break;
	    case '7':
		strcpy(binoct, "11");
		break;
	}
	if (first > 0) {
	    strncpy(bptr, binoct + (3 - first), first);
            *(bptr + first) = '\0';
	    bptr += first;
	    first = 0;
	}
	else {
	    strcpy(bptr, binoct);
	    bptr += 3;
	}
	optr++;
    }
    return bitstring;
}

/* decimal to binary */

char *dec2binary(char *uval, int bits)
{
    int first, dval, hexc;
    char *bitstring = (char *)malloc(1 + bits);
    char *hptr, *bptr, *hstring, *nval;
    char binhex[5];

    first = bits % 4;
    hexc = ((first == 0) ? 0 : 1) + bits >> 2;	/* Number of hex characters */
    hstring = (char *)malloc(1 + hexc);

    /* Scan integer value then convert to hex */
    sscanf(uval, "%d", &dval);
    sprintf(hstring, "%0*x", hexc, dval);
    
    hptr = hstring;
    bptr = bitstring;
    while (*hptr != '\0') {
	switch(*hptr) {
	    case '0':
		strcpy(binhex, "0000");
		break;
	    case '1':
		strcpy(binhex, "0001");
		break;
	    case '2':
		strcpy(binhex, "0010");
		break;
	    case '3':
		strcpy(binhex, "0011");
		break;
	    case '4':
		strcpy(binhex, "0100");
		break;
	    case '5':
		strcpy(binhex, "0101");
		break;
	    case '6':
		strcpy(binhex, "0110");
		break;
	    case '7':
		strcpy(binhex, "0111");
		break;
	    case '8':
		strcpy(binhex, "1000");
		break;
	    case '9':
		strcpy(binhex, "1001");
		break;
	    case 'a':
		strcpy(binhex, "1010");
		break;
	    case 'b':
		strcpy(binhex, "1011");
		break;
	    case 'c':
		strcpy(binhex, "1100");
		break;
	    case 'd':
		strcpy(binhex, "1101");
		break;
	    case 'e':
		strcpy(binhex, "1110");
		break;
	    case 'f':
		strcpy(binhex, "1111");
		break;
	}
	if (first > 0) {
	    strncpy(bptr, binhex + (4 - first), first);
	    bptr += first;
	    first = 0;
	}
	else {
	    strcpy(bptr, binhex);
	    bptr += 4;
	}
	hptr++;
    }
    return bitstring;
}

/*----------------------------------------------------------------------*/
/* Recursion callback function for each item in the cellrec properties  */
/* hash table                                                           */
/*----------------------------------------------------------------------*/

struct nlist *output_props(struct hashlist *p, void *cptr)
{
    char *propval = (char *)(p->ptr);
    FILE *outf = (FILE *)cptr;

    fprintf(outf, ".%s(%s),\n", p->name, propval);
    return NULL;
}

/*--------------------------------------------------------------*/
/* Find the idx'th component of a net name.  This pulls the	*/
/* single wire name out of an indexed or concatenated array.	*/
/*								*/
/* Note that this routine does not handle nested braces.	*/
/*--------------------------------------------------------------*/

char *GetIndexedNet(char *netname, int ridx, struct cellrec *topcell)
{
    int i, alen, idx;
    struct netrec wb;
    char *sptr, *pptr, savc, *bptr;
    static char *subname = NULL;
    if (subname == NULL) subname = (char *)malloc(1);

    if (*netname == '{') {
	sptr = netname + 1;
	i = 0;
	while (i <= ridx) {
	    /* Advance to next comma or close-brace */
	    pptr = strchr(sptr, ',');
	    if (pptr == NULL) pptr = strchr(sptr, '}');
	    if (pptr == NULL) pptr = sptr + strlen(sptr) - 1;

	    savc = *pptr;
	    *pptr = '\0';

	    /* Does the array component at sptr have array bounds? */
	    GetBus(sptr, &wb, &topcell->nets);
	    if (wb.start != -1) {
		alen = (wb.start - wb.end);
		if (alen < 0) alen = -alen;
		if (i + alen < ridx)
		    i += alen;
		else {
		    if (wb.start < wb.end) idx = wb.start + (ridx - i);
		    else idx = wb.start - (ridx - i);
		    bptr = strrchr(sptr, '[');
		    if (bptr != NULL) *bptr = '\0';
		    subname = (char *)realloc(subname, strlen(sptr) + 10);
		    sprintf(subname, "%s[%d]", sptr, idx);
		    i = ridx;
		    if (bptr != NULL) *bptr = '[';
		}
	    }
	    else {
		if (i == ridx) {
		    subname = (char *)realloc(subname, strlen(sptr) + 1);
		    sprintf(subname, "%s", sptr);
		}
		i++;
	    }
	    *pptr = savc;
	}
    }
    else {
	GetBus(netname, &wb, &topcell->nets);
	idx = (wb.start > wb.end) ? (wb.start - ridx) : (wb.start + ridx);
	bptr = strrchr(netname, '[');
	if (bptr != NULL) *bptr = '\0';

	subname = (char *)realloc(subname, strlen(netname) + 10);
	sprintf(subname, "%s[%d]", netname, idx);
	if (bptr != NULL) *bptr = '[';
    }
    return subname;
}

/*--------------------------------------------------------------*/
/* write_output							*/
/*								*/
/*         ARGS: 						*/
/*      RETURNS: 1 to OS					*/
/* SIDE EFFECTS: 						*/
/*--------------------------------------------------------------*/

int write_output(struct cellrec *topcell, unsigned char Flags, char *outname)
{
    FILE *outfptr = stdout;
    int result = 0;
    int nunconn = 0;
    int arrayidx = -1;

    GATE gate = (GATE)NULL;

    struct netrec *net;
    struct portrec *port;
    struct instance *inst;

    if (outname != NULL) {
	outfptr = fopen(outname, "w");
	if (outfptr == NULL) {
	    fprintf(stderr, "Error:  Cannot open file %s for writing.\n", outname);
	    return 1;
	}
    }

    /* Write output module header */
    fprintf(outfptr, "/* Verilog module written by vlog2Verilog (qflow) */\n");

    if (Flags & IMPLICIT_POWER)
        fprintf(outfptr, "/* With explicit power connections */\n");
    if (!(Flags & MAINTAIN_CASE))
        fprintf(outfptr, "/* With case-insensitive names (SPICE-compatible) */\n");
    if (Flags & BIT_BLAST)
        fprintf(outfptr, "/* With bit-blasted vectors */\n");
    if (Flags & NONAME_POWER)
        fprintf(outfptr, "/* With power connections converted to binary 1, 0 */\n");
    fprintf(outfptr, "\n");

    fprintf(outfptr, "module %s(\n", topcell->name);

    if (Flags & IMPLICIT_POWER) {
	fprintf(outfptr, "    inout %s,\n", VddNet);
	fprintf(outfptr, "    inout %s,\n", GndNet);
    }

    for (port = topcell->portlist; port; port = port->next) {
	if (port->name == NULL) continue;
	switch(port->direction) {
	    case PORT_INPUT:
		fprintf(outfptr, "    input ");
		break;
	    case PORT_OUTPUT:
		fprintf(outfptr, "    output ");
		break;
	    case PORT_INOUT:
		fprintf(outfptr, "    inout ");
		break;
	}
	net = HashLookup(port->name, &topcell->nets);
	if (net && net->start >= 0 && net->end >= 0) {
	    fprintf(outfptr, "[%d:%d] ", net->start, net->end);
	}
	fprintf(outfptr, "%s", port->name);
	if (port->next) fprintf(outfptr, ",");
	fprintf(outfptr, "\n");
    }
    fprintf(outfptr, ");\n\n");

    /* Declare all wires */

    if (!(Flags & IMPLICIT_POWER) && !(Flags & NONAME_POWER)) {
	fprintf(outfptr, "wire %s = 1'b1;\n", VddNet);
	fprintf(outfptr, "wire %s = 1'b0;\n\n", GndNet);
    }

    RecurseHashTablePointer(&topcell->nets, output_wires, outfptr);
    fprintf(outfptr, "\n");

    /* Write instances in the order of the input file */

    for (inst = topcell->instlist; inst; ) {
	int nprops = RecurseHashTable(&inst->propdict, CountHashTableEntries);
	fprintf(outfptr, "%s ", inst->cellname);
	if (nprops > 0) {
	    fprintf(outfptr, "#(\n");
	    RecurseHashTablePointer(&inst->propdict, output_props, outfptr);
	    fprintf(outfptr, ") ");
	}
	if (inst->cellname)
	    fprintf(outfptr, "%s", inst->instname);
	else {
	    fprintf(outfptr, "vlog2Verilog:  No cell for instance %s\n", inst->instname);
	    result = 1;		// Set error result but continue output.
	}
	if (inst->arraystart != -1) {
	    if (Flags & BIT_BLAST) {
		if (arrayidx == -1) arrayidx = inst->arraystart;
		fprintf(outfptr, "[%d]", arrayidx);
	    }
	    else {
		fprintf(outfptr, " [%d:%d]", inst->arraystart, inst->arrayend);
	    }
	}
	fprintf(outfptr, " (\n");

	// If there is a gate record read from LEF, keep a pointer to it.
	if (GateInfo != NULL)
	    gate = (GATE)HashLookup(inst->cellname, &Lefhash);

	if (Flags & IMPLICIT_POWER) {

	    /* If any LEF files were read, then get the power and	*/
	    /* ground net names from the LEF file definition.		*/

	    if (gate) {
		int n;
		u_char found = 0;
		for (n = 0; n < gate->nodes; n++) {
		    if (gate->use[n] == PORT_USE_POWER) {
			fprintf(outfptr, "    .%s(%s),\n", gate->node[n], VddNet);
			found++;
		    }
		    else if (gate->use[n] == PORT_USE_GROUND) {
			fprintf(outfptr, "    .%s(%s),\n", gate->node[n], GndNet);
			found++;
		    }
		    if (found == 2) break;
		}
	    }
	    else {
		/* Fall back on VddNet and GndNet names */
		fprintf(outfptr, "    .%s(%s),\n", GndNet, GndNet);
		fprintf(outfptr, "    .%s(%s),\n", VddNet, VddNet);
	    }
	}

	/* Write each port and net connection */
	for (port = inst->portlist; port; port = port->next) {

	    /* If writing explicit power net names, then watch	*/
	    /* for power connections encoded as binary, and	*/
	    /* convert them to the power bus names.		*/

	    if ((Flags & IMPLICIT_POWER) || (!(Flags & NONAME_POWER))) {
		int brepeat = 0;
		char is_array = FALSE, saveptr;
		char *sptr = port->net, *nptr;
		char *expand = (char *)malloc(1);

		*expand = '\0';
		if (*sptr == '{') {
		    is_array = TRUE;
		    sptr++;
		    expand = (char *)realloc(expand, 2);
		    strcpy(expand, "{");
		}
		while ((*sptr != '}') && (*sptr != '\0')) {
		    int nest = 0;

		    nptr = sptr + 1;
		    while ((*nptr != '\0') && (*nptr != ',')) {
			if (*nptr == '{') nest++;
			if (*nptr == '}') {
			    if (nest == 0) break;
			    else nest--;
			}
			nptr++;
		    }
		    saveptr = *nptr;
		    *nptr = '\0';

		    if (isdigit(*sptr) || (*sptr == '\'')) {
			char *bptr = sptr;
			if (sscanf(bptr, "%d", &brepeat) == 0) brepeat = -1;
			while (isdigit(*bptr)) bptr++;

			/* Is digit followed by "'" (fixed values 1 or 0)? */

			if (*bptr == '\'') {
			    char *bitstring;
			    bptr++;

			    /* Important note:  Need to check if 'x' is	*/
			    /* on an output, in which case it should be	*/
			    /* treated like 'z' (unconnected).		*/

			    /* Ports in verilog instances have no	*/
			    /* direction information so it is necessary	*/
			    /* to pull the information from the LEF	*/
			    /* record of the cell.			*/

			    if (gate) {
				int n;
				for (n = 0; n < gate->nodes; n++) {
				    if (!strcmp(gate->node[n], port->name)) {
					switch (gate->direction[n]) {
					    case PORT_CLASS_INPUT:
						port->direction = PORT_INPUT;
						break;
					    case PORT_CLASS_OUTPUT:
						port->direction = PORT_OUTPUT;
						break;
					    default:
						port->direction = PORT_INOUT;
						break;
					}
					break;
				    }
				}
			    }

			    if (port->direction != PORT_INPUT) {
				char *xptr;
				for (xptr = bptr; *xptr != '\0'; xptr++) {
				    if ((*xptr == 'X') || (*xptr == 'x'))
					*xptr = 'z';
				}
			    }

			    switch(*bptr) {
				case 'd':
				    bitstring = dec2binary(bptr + 1, brepeat);
				    break;
				case 'h':
				    bitstring = hex2binary(bptr + 1, brepeat);
				    break;
				case 'o':
				    bitstring = oct2binary(bptr + 1, brepeat);
				    break;
				default:
				    bitstring = strdup(bptr + 1);
				    break;
			    }

			    if (brepeat < 0) brepeat = strlen(bitstring);

			    if ((brepeat > 1) && (is_array == FALSE)) {
				is_array = TRUE;
				expand = (char *)realloc(expand, strlen(expand) + 2);
				strcat(expand, "{");
			    }

			    bptr = bitstring;
			    while (*bptr != '\0') {
				if (*bptr == '1') {
				    expand = (char *)realloc(expand,
						strlen(expand) +
						strlen(VddNet) + 2);
				    strcat(expand, VddNet);
				}
				else if (tolower(*bptr) == 'z') {
				    char unconnect[20];
				    /* Unconnected node:  Make a new node name. */
				    /* This is a single bit, so it can be	*/
				    /* implicitly declared.			*/
				    sprintf(unconnect, "\\$_unconn_%d_ ", nunconn++);
				    expand = (char *)realloc(expand,
						strlen(expand) + strlen(unconnect)
						+ 1);
				    strcat(expand, unconnect);
				}
				else { /* Note: If 'X', then ground it */
				    expand = (char *)realloc(expand,
						strlen(expand) +
						strlen(GndNet) + 2);
				    strcat(expand, GndNet);
				}
				brepeat--;
				if (brepeat > 0)
				    strcat(expand, ",");
				bptr++;
				if (brepeat <= 0) break;
			    }
			    if (bptr == bitstring) {
				fprintf(stderr, "Warning: Cannot parse \"%s\"\n", sptr);
			    }
			    while (brepeat > 0) {
				if ((bptr > bitstring) && (*(bptr - 1) == '1')) {
				    expand = (char *)realloc(expand,
						strlen(expand) +
						strlen(VddNet) + 2);
				    strcat(expand, VddNet);
				}
				else { /* Note: If 'X', then ground it */
				    expand = (char *)realloc(expand,
						strlen(expand) +
						strlen(GndNet) + 2);
				    strcat(expand, GndNet);
				}
				brepeat--;
				if (brepeat > 0)
				    strcat(expand, ",");
			    }
			    free(bitstring);
			}

			/* Otherwise add to "expand" verbatim */
			else {
			    expand = (char *)realloc(expand, strlen(expand) +
					strlen(sptr) + 1);
			    strcat(expand, sptr);
			}
		    }
		    else {
			/* Normal net name, add to "expand" */
			expand = (char *)realloc(expand, strlen(expand) +
				strlen(sptr) + 1);
			strcat(expand, sptr);
		    }
		    if (saveptr == ',') {
			expand = (char *)realloc(expand, strlen(expand) + 2);
			strcat(expand, ",");
		    }
		    *nptr = saveptr;
		    sptr = nptr;
		    if (saveptr != '\0') sptr++;
		}

		if (is_array) {
		    expand = (char *)realloc(expand, strlen(expand) + 2);
		    strcat(expand, "}");
		}

		/* Replace port->net */
		
		free(port->net);
		port->net = expand;
	    }
	    fprintf(outfptr, "    .%s(", port->name);
	    if ((Flags & BIT_BLAST) && (arrayidx != -1)) {
		/* Find the index from the start and pull that item from port->net */
		int ridx;
		ridx = arrayidx - inst->arraystart;
		if (ridx < 0) ridx = -ridx;
		fprintf(outfptr, "%s", GetIndexedNet(port->net, ridx, topcell));
	    }
	    else
		fprintf(outfptr, "%s", port->net);
	    fprintf(outfptr, ")");
	    if (port->next) fprintf(outfptr, ",");
	    fprintf(outfptr, "\n");
	}
	fprintf(outfptr, ");\n\n");

	/* For bit-blasted output, output each element of an array separately. */
	if (Flags & BIT_BLAST) {
	    if (arrayidx == inst->arrayend) {
		inst = inst->next;
		arrayidx = -1;
	    }
	    else if (arrayidx < inst->arrayend)
		arrayidx++;
	    else if (arrayidx > inst->arrayend)
		arrayidx--;
	}
	else
	    inst = inst->next;
    }

    if (Flags & ADD_ANTENNA) {
	char *antennapin = NULL;
	GATE gate, acell = NULL;
	double asize;

	/* Find the cell name that matches the antenna cell	*/
	/* Can't use the hash table here because name may be a	*/
 	/* prefix.  If more than one cell matches by prefix,	*/
	/* then use the cell with the smallest area.		*/

	for (gate = GateInfo; gate; gate = gate->next) {
	    if (!strncmp(gate->gatename, AntennaCell, strlen(AntennaCell))) {
		if (!strcmp(gate->gatename, AntennaCell)) {
		    acell = gate;
		    break;
		}
		else if (acell == NULL) {
		    acell = gate;
		}
		else {
		    if (gate->width < acell->width) {
			acell = gate;
		    }
		}
	    }
	}

	if (acell) {
	    int i;
	    /* Find the node that isn't a power pin */
	    for (i = 0; i < acell->nodes; i++) {
		if (acell->use[i] != PORT_USE_POWER &&
			acell->use[i] != PORT_USE_GROUND) {
		    antennapin = acell->node[i];
		    break;
		}
	    }
	}

	if (antennapin) {
	    int antcnt = 0;

	    /* Add antenna cells to all module inputs */

	    for (port = topcell->portlist; port; port = port->next) {
		if (port->name == NULL) continue;
		switch(port->direction) {
		    case PORT_INPUT:
			fprintf(outfptr, "%s antenna_%d ", acell->gatename, antcnt);

			net = HashLookup(port->name, &topcell->nets);
			if (net && net->start >= 0 && net->end >= 0) {
			    fprintf(outfptr, "[%d:%d] ", net->start, net->end);
			}

			fprintf(outfptr, "(\n");
			fprintf(outfptr, "   .%s(%s)\n",  antennapin, port->name);
			fprintf(outfptr, ");\n\n");
			antcnt++;
			break;
		}
	    }
	}
    }

    /* End the module */
    fprintf(outfptr, "endmodule\n");

    if (outname != NULL) fclose(outfptr);

    fflush(stdout);
    return result;
}

/*--------------------------------------------------------------*/
/* C helpmessage - tell user how to use the program		*/
/*								*/
/*         ARGS: 						*/
/*      RETURNS: 1 to OS					*/
/* SIDE EFFECTS: 						*/
/*--------------------------------------------------------------*/

void helpmessage(FILE *outf)
{
    fprintf(outf, "vlog2Verilog [-options] <netlist>\n");
    fprintf(outf, "\n");
    fprintf(outf, "vlog2Verilog converts a netlist in one verilog style to\n");
    fprintf(outf, "another. LEF files may be given as inputs to determine\n");
    fprintf(outf, "power and ground net names for cells.\n");
    fprintf(outf, "\n");
    fprintf(outf, "options:\n");
    fprintf(outf, "\n");
    fprintf(outf, "  -h         Print this message\n");    
    fprintf(outf, "  -o <path>  Set output filename (otherwise output is on stdout).\n");    
    fprintf(outf, "  -p         Don't add power nodes to instances\n");
    fprintf(outf, "             (only nodes present in the instance used)\n");
    fprintf(outf, "  -b         Remove vectors (bit-blasted)\n");
    fprintf(outf, "  -c         Case-insensitive output (SPICE compatible) \n");
    fprintf(outf, "  -n         Convert power nets to binary 1 and 0\n");
    fprintf(outf, "  -a	<name>	Add antenna cells to module input pins.\n");
    fprintf(outf, "  -l <path>  Read LEF file from <path>\n");
    fprintf(outf, "  -v <name>  Use <name> for power net (default \"Vdd\")\n");
    fprintf(outf, "  -g <name>  Use <name> for ground net (default \"Gnd\")\n");

} /* helpmessage() */

