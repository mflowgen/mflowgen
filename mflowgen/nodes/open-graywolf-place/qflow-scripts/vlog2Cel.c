//----------------------------------------------------------------
// vlog2Cel
//----------------------------------------------------------------
// Generate a .cel file for the GrayWolf placement tool from a
// verilog source, plus LEF files for the technology, standard
// cells, and (if present) hard macros.
//
// Revision 0, 2018-12-1: First release by R. Timothy Edwards.
//
// This program is written in ISO C99.
//----------------------------------------------------------------

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>	/* for getopt() */
#include <math.h>
#include <ctype.h>
#include <float.h>

#include "hash.h"
#include "readverilog.h"
#include "readlef.h"

int write_output(struct cellrec *, int, char *);
void helpmessage(FILE *outf);

char *VddNet = NULL;
char *GndNet = NULL;

struct hashtable LEFhash;

/*--------------------------------------------------------------*/

int main (int argc, char *argv[])
{
    int i, units, result;

    char *outfile = NULL;
    char *vlogname = NULL;
    struct cellrec *topcell;

    VddNet = strdup("VDD");
    GndNet = strdup("VSS");

    InitializeHashTable(&LEFhash, SMALLHASHSIZE);
    units = 100;	/* Default value is centimicrons */

    while ((i = getopt(argc, argv, "hHu:l:o:")) != EOF) {
	switch (i) {
	    case 'h':
	    case 'H':
		helpmessage(stdout);
		return 0;
	    case 'u':
		if (sscanf(optarg, "%d", &units) != 1) {
		    fprintf(stderr, "Cannot read integer units from \"%s\"\n", optarg);
		}
		break;
	    case 'l':
		LefRead(optarg);		/* Can be called multiple times */
		break;
	    case 'o':
		outfile = strdup(optarg);
		break;
	    default:
		fprintf(stderr, "Bad switch \"%c\"\n", (char)i);
		helpmessage(stderr);
		return 1;
	}
    }

    if (optind < argc) {
	vlogname = strdup(argv[optind]);
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
	    HashPtrInstall(gate->gatename, gate, &LEFhash);
	}
    }

    topcell = ReadVerilog(vlogname);
    result = write_output(topcell, units, outfile);
    return result;
}

/*--------------------------------------------------------------*/
/* write_output: Generate the .cel file output.			*/
/*								*/
/*         ARGS: 						*/
/*      RETURNS: 0 on success, 1 on error			*/
/* SIDE EFFECTS: 						*/
/*--------------------------------------------------------------*/

int write_output(struct cellrec *topcell, int units, char *outfile)
{
    FILE *outfptr = stdout;
    int result = 0;

    struct netrec *net;
    struct portrec *port;
    struct instance *inst;

    GATE gateginfo;

    int i, j, layers, feedx, cellidx, kidx;
    int llx, lly, cllx, clly, urx, ury, width, height, px, py;
    int *pitchx, *pitchy;
    int lvert = -1;

    if (outfile != NULL) {
	outfptr = fopen(outfile, "w");
	if (outfptr == NULL) {
	    fprintf(stderr, "Error:  Failed to open file %s for output\n",
			outfile);
	    return 1;
	}
    }

    /* Count route layers (just need a maximum for memory allocation) */
    layers = LefGetMaxRouteLayer();

    pitchx = (int *)calloc((layers + 1), sizeof(int));
    pitchy = (int *)calloc((layers + 1), sizeof(int));

    /* Pull pitch information from LEF database */

    for (i = 0; i <= layers; i++) {
	pitchx[i] = (int)(LefGetRoutePitchX(i) * (double)units + 0.5);
	pitchy[i] = (int)(LefGetRoutePitchY(i) * (double)units + 0.5);
    } 

    /* Find first vertical route that is not route 0 */
    for (i = 1; i <= layers; i++) {
	if (LefGetRouteOrientation(i) == 0) {
	    lvert = i;
	    break;
	}
    }

    /* If X pitch on layer lvert is zero, then infinite loops happen */
    if (lvert < 0) {
	fprintf(stderr, "Error:  Failed to get layer information; cannot continue.\n");
	return 1;
    }
    else if (pitchx[lvert] <= 0) {
	fprintf(stderr, "Error:  Bad value %d for X pitch on vertical route"
			" layer %d;  cannot continue.\n",
			pitchx[lvert], lvert);
	return 1;
    }

    /* Write instances in the order of the input file */

    cellidx = 1;
    kidx = 1;
    for (inst = topcell->instlist; inst; inst = inst->next) {
	if (inst->cellname)
	    gateginfo = HashLookup(inst->cellname, &LEFhash);
	else
	    gateginfo = NULL;

	if (gateginfo == NULL) {
	    fprintf(stderr, "Error:  Cell \"%s\" of instance \"%s\" not found"
			" in LEF databases!\n", inst->cellname, inst->instname);
	    result = 1;		// Set error result but continue output.
	    continue;
	}

	width = (int)(gateginfo->width * (double)units + 0.5);
	height = (int)(gateginfo->height * (double)units + 0.5);

	cllx = -(width >> 1);
	clly = -(height >> 1);
	urx = width + cllx;
	ury = height + clly;
	
	fprintf(outfptr, "cell %d %s:%s\n", cellidx, inst->cellname, inst->instname);
	fprintf(outfptr, "left %d right %d bottom %d top %d\n",
		cllx, urx, clly, ury);
	cellidx++;

	/* Generate implicit feedthroughs to satisfy global routing, as many	*/
	/* as will fit on the vertical track pitch.				*/

	feedx = cllx + pitchx[lvert] / 2 + pitchx[lvert];
	kidx = 1;
	while (feedx < urx) {
	    fprintf(outfptr, "pin name twfeed%d signal TW_PASS_THRU layer %d %d %d\n",
			kidx, lvert, feedx, clly);
	    fprintf(outfptr, "   equiv name twfeed%d layer %d %d %d\n",
			kidx, lvert, feedx, ury);
	    feedx += pitchx[lvert];
	    kidx++;
	}

	/* Write each port and net connection */
	for (port = inst->portlist; port; port = port->next) {
	    int is_array = FALSE;

	    /* Verilog backslash-escaped names have spaces that	*/
	    /* break pretty much every other format, so replace	*/
	    /* the space with the (much more sensible) second	*/
	    /* backslash.  This can be detected and changed	*/
	    /* back by programs converting the syntax back into	*/
	    /* verilog.						*/

	    if (*port->net == '\\') {
		char *sptr;
		sptr = strchr(port->net, ' ');
		if (sptr != NULL) *sptr = '\\';
	    }

	    /* Find the port name in the gate pin list */
	    for (j = 0; j < gateginfo->nodes; j++) {
		if (!strcmp(port->name, gateginfo->node[j])) break;
	    }
	    if (j == gateginfo->nodes) {
		/* Is this a bus? */
		for (j = 0; j < gateginfo->nodes; j++) {
		    char *delim = strrchr(gateginfo->node[j], '[');
		    if (delim != NULL) {
			*delim = '\0';
			if (!strcmp(port->name, gateginfo->node[j]))
			    is_array = TRUE;
			*delim = '[';
			if (is_array) break;
		    }
		}
	    }

	    if (j == gateginfo->nodes) {
		fprintf(stderr, "Error:  Pin \"%s\" not found in LEF macro \"%s\"!\n",
			port->name, gateginfo->gatename);
		result = 1;	// Set error result but continue output
	    }
	    else if (is_array == FALSE) {
		/* Pull pin position from first rectangle in taps list.  This	*/
		/* does not have to be accurate;  just representative.		*/
		int bufidx;
		char *sigptr;
		DSEG tap = gateginfo->taps[j];

		/* If LEF file failed to specify pin geometry, then use cell center */
		if (tap == NULL) {
		    px = cllx;
		    py = clly;
		}
		else {
		    llx = (int)(tap->x1 * (double)units + 0.5);
		    lly = (int)(tap->y1 * (double)units + 0.5);
		    urx = (int)(tap->x2 * (double)units + 0.5);
		    ury = (int)(tap->y2 * (double)units + 0.5);
		    px = cllx + ((llx + urx) / 2);
		    py = clly + ((lly + ury) / 2);
		}

		if (((sigptr = strstr(port->net, "_bF$buf")) != NULL) &&
			((sscanf(sigptr + 7, "%d", &bufidx)) == 1) &&
			(gateginfo->direction[j] == PORT_CLASS_INPUT)) {
		    fprintf(outfptr, "pin_group\n");
		    *sigptr = '\0';
		    fprintf(outfptr, "pin name %s_bF$pin/%s ",
				port->net, port->name);
		    *sigptr = '_';
		    fprintf(outfptr, "signal %s layer %d %d %d\n",
				port->net, lvert, px, py);
		    fprintf(outfptr, "end_pin_group\n");
		}
		else {
		    fprintf(outfptr, "pin name %s signal %s layer %d %d %d\n",
				port->name, port->net, lvert, px, py);
		}
	    }
	    else {	/* Handle arrays */
		char *apin, *anet, *dptr, *cptr;
		int a, pidx, armax, armin;

		armax = armin = 0;
		for (j = 0; j < gateginfo->nodes; j++) {
		    char *delim = strrchr(gateginfo->node[j], '[');
		    if (delim != NULL) {
			*delim = '\0';
			if (!strcmp(port->name, gateginfo->node[j])) {
			    if (sscanf(delim + 1, "%d", &pidx) == 1) {
				if (pidx > armax) armax = pidx;
				if (pidx < armin) armin = pidx;
			    }
			}
			*delim = '[';
		    }
		}

		/* To do:  Need to check if array is high-to-low or low-to-high */
		/* Presently assuming arrays are always defined high-to-low	*/

		apin = (char *)malloc(strlen(port->name) + 15);
		for (a = armax; a >= armin; a--) {
		    sprintf(apin, "%s[%d]", port->name, a);

		    /* If net is not delimited by {...} then it is also	*/
		    /* an array.  Otherwise, find the nth element in	*/
		    /* the brace-enclosed set.				*/

		    /* To do: if any component of the array is a vector	*/
		    /* then we need to count bits in that vector.	*/

		    if (*port->net == '{') {
			int aidx;
			char *sptr, ssave;
			char *pptr = port->net + 1;
			for (aidx = 0; aidx < (armax - a); aidx++) {
			    sptr = pptr;
			    while (*sptr != ',' && *sptr != '}') sptr++;
			    pptr = sptr + 1;
			}
			sptr = pptr;
			if (*sptr != '\0') {
			    while (*sptr != ',' && *sptr != '}') sptr++;
			    ssave = *sptr;
			    *sptr = '\0';
			    anet = (char *)malloc(strlen(pptr) + 1);
			    sprintf(anet, "%s", pptr);
			    *sptr = ssave;
			}
			else {
			    anet = NULL;	/* Must handle this error! */
			}
		    }
		    else if (((dptr = strrchr(port->net, '[')) != NULL) &&
				((cptr = strrchr(port->net, ':')) != NULL)) {
			int fhigh, flow, fidx;
			sscanf(dptr + 1, "%d", &fhigh);
			sscanf(cptr + 1, "%d", &flow);
			if (fhigh > flow) fidx = fhigh - (armax - a);
			else fidx = flow + (armax - a);
			anet = (char *)malloc(strlen(port->net) + 15);
			*dptr = '\0';
			sprintf(anet, "%s[%d]", port->net, fidx);
			*dptr = '[';
		    }
		    else {
			anet = (char *)malloc(strlen(port->net) + 15);
			sprintf(anet, "%s[%d]", port->net, a);
		    }

		    /* Find the corresponding port bit */
		    for (j = 0; j < gateginfo->nodes; j++) {
			if (anet == NULL) break;
			if (!strcmp(apin, gateginfo->node[j])) {

			    /* Pull pin position from first rectangle in taps	*/
			    /* list.  This does not have to be accurate;  just	*/
			    /* representative.					*/
			    int bufidx;
			    char *sigptr;
			    DSEG tap = gateginfo->taps[j];

			    /* If LEF file failed to specify pin geometry, then	*/
			    /* use cell center 					*/
			    if (tap == NULL) {
				px = cllx;
				py = clly;
			    }
			    else {
				llx = (int)(tap->x1 * (double)units + 0.5);
				lly = (int)(tap->y1 * (double)units + 0.5);
				urx = (int)(tap->x2 * (double)units + 0.5);
				ury = (int)(tap->y2 * (double)units + 0.5);
				px = cllx + ((llx + urx) / 2);
				py = clly + ((lly + ury) / 2);
			    }

			    if (((sigptr = strstr(port->net, "_bF$buf")) != NULL) &&
					((sscanf(sigptr + 7, "%d", &bufidx)) == 1) &&
					(gateginfo->direction[j] == PORT_CLASS_INPUT)) {
				fprintf(outfptr, "pin_group\n");
				*sigptr = '\0';
				fprintf(outfptr, "pin name %s_bF$pin/%s ",
						anet, apin);
				*sigptr = '_';
				fprintf(outfptr, "signal %s layer %d %d %d\n",
						anet, lvert, px, py);
				fprintf(outfptr, "end_pin_group\n");
			    }
			    else {
				fprintf(outfptr, "pin name %s signal %s layer %d %d %d\n",
					apin, anet, lvert, px, py);
			    }
			}
		    }
		    free(anet);
		}
		free(apin);
	    }
	}
    }

    /* Compute size of a pin as the route pitch (px and py are half sizes). */
    /* This prevents pins from being spaced tighter than the route pitches. */

    px = pitchx[lvert] >> 1;
    py = pitchy[lvert] >> 1;

    /* Various attempts to get a valid value for the Y pitch. */
    if (py == 0) py = pitchy[lvert - 1];
    if (py == 0) py = pitchy[lvert + 1];
    if (py == 0) py = pitchx[lvert];

    /* Output pins from the verilog input/output list */

    kidx = 1;
    for (port = topcell->portlist; port; port = port->next) {
	if (port->name == NULL) continue;
	net = HashLookup(port->name, &topcell->nets);
	if (net && net->start >= 0 && net->end >= 0) {
	    if (net->start > net->end) {
		for (i = net->start; i >= net->end; i--) {
		    fprintf(outfptr, "pad %d name twpin_%s[%d]\n", kidx,
				port->name, i);
		    fprintf(outfptr, "corners 4 %d %d %d %d %d %d %d %d\n",
				-px, -py, -px, py, px, py, px, -py);
		    fprintf(outfptr, "pin name %s[%d] signal %s[%d] layer %d 0 0\n",
				port->name, i, port->name, i, lvert);
		    kidx++;
		}
	    }
	    else {
		for (i = net->start; i <= net->end; i++) {
		    fprintf(outfptr, "pad %d name twpin_%s[%d]\n", kidx,
				port->name, i);
		    fprintf(outfptr, "corners 4 %d %d %d %d %d %d %d %d\n",
				-px, -py, -px, py, px, py, px, -py);
		    fprintf(outfptr, "pin name %s[%d] signal %s[%d] layer %d 0 0\n",
				port->name, i, port->name, i, lvert);
		    kidx++;
		}
	    }
	}
	else {
	    fprintf(outfptr, "pad %d name twpin_%s\n", kidx, port->name);
	    fprintf(outfptr, "corners 4 %d %d %d %d %d %d %d %d\n",
			-px, -py, -px, py, px, py, px, -py);
	    fprintf(outfptr, "pin name %s signal %s layer %d 0 0\n",
			port->name, port->name, lvert);
	    kidx++;
	}
	fprintf(outfptr, "\n");

    }
    if (outfile != NULL) fclose(outfptr);

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
    fprintf(outf, "vlog2Cel [-options] <netlist>\n");
    fprintf(outf, "\n");
    fprintf(outf, "vlog2Cel converts a netlist in verilog to a .cel file\n");
    fprintf(outf, "for the GrayWolf placement tool. Output on stdout.  LEF\n");
    fprintf(outf, "files are required for determining cell dimensions.\n");
    fprintf(outf, "\n");
    fprintf(outf, "options:\n");
    fprintf(outf, "\n");
    fprintf(outf, "  -h         Print this message\n");    
    fprintf(outf, "  -o <path>  Output filename is <path>, otherwise output"
			" on stdout.\n");
    fprintf(outf, "  -u <value> Use scale <value> for units (default "
			"100 = centimicrons)\n");
    fprintf(outf, "  -l <path>  Read LEF file from <path> (may be called multiple"
			" times)\n");

} /* helpmessage() */

