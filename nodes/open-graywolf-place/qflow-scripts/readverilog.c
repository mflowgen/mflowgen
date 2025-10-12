/*----------------------------------------------------------------------*/
/* readverilog.c -- Input for Verilog format (structural verilog only)	*/
/*									*/
/* Adapted from verilog.c in netgen-1.5					*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/* The verilog input is limited to "structural verilog", that is,	*/
/* verilog code that only defines inputs, outputs, local nodes (via the	*/
/* "wire" statement), and instanced modules.  All modules are read down	*/
/* to the point where either a module (1) does not conform to the	*/
/* requirements above, or (2) has no module definition, in which case	*/
/* it is treated as a "black box" subcircuit and therefore becomes a	*/
/* low-level device.  Because in verilog syntax all instances of a	*/
/* module repeat both the module pin names and the local connections,	*/
/* placeholders can be built without the need to redefine pins later,	*/
/* as must be done for formats like SPICE that don't declare pin names	*/
/* in an instance call.							*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/* Note that use of 1'b0 or 1'b1 and similar variants is prohibited;	*/
/* the structural netlist should either declare VSS and/or VDD as	*/
/* inputs, or use tie-high and tie-low standard cells.			*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/* Most verilog syntax has been captured below.  Still to do:  Handle	*/
/* wires that are created on the fly using {...} notation, including	*/
/* the {n{...}} concatenation method.  Currently this syntax is only	*/
/* handled in nets connected to instance pins.				*/
/*----------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include <sys/types.h>
#include <pwd.h>

#include "hash.h"
#include "readverilog.h"

/*------------------------------------------------------*/
/* Global variables					*/
/*------------------------------------------------------*/

struct filestack *OpenFiles = NULL;
int linesize = 0;	/* Amount of memory allocated for line */
int vlinenum = 0;
char *nexttok;
char *linetok;
char *line = NULL;	/* The line read in */
FILE *infile = NULL;

struct hashtable verilogparams;
struct hashtable verilogdefs;
struct hashtable verilogvectors;

/*------------------------------------------------------*/
/* Stack handling (push and pop)			*/
/*------------------------------------------------------*/

void PushStack(struct cellrec *cell, struct cellstack **top)
{
   struct cellstack *newstack;

   newstack = (struct cellstack *)calloc(1, sizeof(struct cellstack));
   newstack->cell = cell;
   newstack->next = *top;
   *top = newstack;
}

/*------------------------------------------------------*/

struct cellrec *PopStack(struct cellstack **top)
{
   struct cellstack *stackptr;
   struct cellrec *cellptr;

   stackptr = *top;
   cellptr = stackptr->cell;
   if (!stackptr) return NULL;
   *top = stackptr->next;
   free(stackptr);

   return cellptr;
}

/*----------------------------------------------------------------------*/
/* Function similar to strtok() for token parsing.  The difference is   */
/* that it takes two sets of delimiters.  The first is whitespace       */
/* delimiters, which separate tokens.  The second is functional         */
/* delimiters, which separate tokens and have additional meaning, such  */
/* as parentheses, commas, semicolons, etc.  The parser needs to know   */
/* when such tokens occur in the string, so they are returned as        */
/* individual tokens.                                                   */
/*                                                                      */
/* Definition of delim2:  String of single delimiter characters.  The   */
/* special character "X" (which is never a delimiter in practice) is    */
/* used to separate single-character delimiters from two-character      */
/* delimiters (this presumably could be further extended as needed).    */
/* so ",;()" would be a valid delimiter set, but to include C-style     */
/* comments and verilog-style parameter lists, one would need           */
/* ",;()X/**///#(".                                                     */
/*----------------------------------------------------------------------*/

char *strdtok(char *pstring, char *delim1, char *delim2)
{
    static char *stoken = NULL;
    static char *sstring = NULL;
    char *s, *s2;
    char first = FALSE;
    int twofer;

    if (pstring != NULL) {
	/* Allocate enough memory to hold the string;  tokens will be put here */
	if (sstring != NULL) free(sstring);
	sstring = (char *)malloc(strlen(pstring) + 1);
	stoken = pstring;
	first = TRUE;
    }

    /* Skip over "delim1" delimiters at the string beginning */
    for (; *stoken; stoken++) {
        for (s2 = delim1; *s2; s2++)
            if (*stoken == *s2)
                break;
        if (*s2 == '\0') break;
    }

    if (*stoken == '\0') return NULL;   /* Finished parsing */

    /* "stoken" is now set.  Now find the end of the current token */
    /* Check string from position stoken.  If a character in "delim2" is found, */
    /* save the character in "lastdelim", null the byte at that position, and   */
    /* return the token.  If a character in "delim1" is found, do the same but  */
    /* continue checking characters as long as there are contiguous "delim1"    */
    /* characters.  If the series ends in a character from "delim2", then treat */
    /* as for "delim2" above.  If not, then set "lastdelim" to a null byte and  */
    /* return the token.                                                        */

    s = stoken;

    /* Special verilog rule:  If a name begins with '\', then all characters	*/
    /* are a valid part of the name until a space character is reached.	  The	*/
    /* space character becomes part of the verilog name.  The remainder of the	*/
    /* name is parsed according to the rules of "delim2".			*/

    if (*s == '\\') {
	while (*s != '\0') {
	    if (*s == ' ') {
		s++;
		break;
	    }
	    s++;
	}
    }

    for (; *s; s++) {
	twofer = TRUE;
	for (s2 = delim2; s2 && *s2; s2++) {
	    if (*s2 == 'X') {
		twofer = FALSE;
		continue;
	    }
	    if (twofer) {
		if ((*s == *s2) && (*(s + 1) == *(s2 + 1))) {
		    if (s == stoken) {
			strncpy(sstring, stoken, 2);
			*(sstring + 2) = '\0';
			stoken = s + 2;
		    }
		    else {
			strncpy(sstring, stoken, (int)(s - stoken));
			*(sstring + (s - stoken)) = '\0';
			stoken = s;
		    }
		    return sstring;
		}
		s2++;
		if (*s2 == '\0') break;
	    }
	    else if (*s == *s2) {
		if (s == stoken) {
		    strncpy(sstring, stoken, 1);
		    *(sstring + 1) = '\0';
		    stoken = s + 1;
		}
		else {
		    strncpy(sstring, stoken, (int)(s - stoken));
		    *(sstring + (s - stoken)) = '\0';
		    stoken = s;
		}
		return sstring;
	    }
	}
	for (s2 = delim1; *s2; s2++) {
	    if (*s == *s2) {
		strncpy(sstring, stoken, (int)(s - stoken));
		*(sstring + (s - stoken)) = '\0';
		stoken = s;
		return sstring;
	    }
	}
    }
    strcpy(sstring, stoken);    /* Just copy to the end */
    stoken = s;
    return sstring;
}

/*----------------------------------------------------------------------*/
/* File opening, closing, and stack handling				*/
/* Return 0 on success, -1 on error.					*/
/*----------------------------------------------------------------------*/

int OpenParseFile(char *name)
{
    /* Push filestack */

    FILE *locfile = NULL;
    struct filestack *newfile;

    locfile = fopen(name, "r");
    vlinenum = 0;
    /* reset the token scanner */
    nexttok = NULL;

    if (locfile != NULL) {
	if (infile != NULL) {
	    newfile = (struct filestack *)malloc(sizeof(struct filestack));
	    newfile->file = infile;
	    newfile->next = OpenFiles;
	    OpenFiles = newfile;
	}
	infile = locfile;
    }
    return (locfile == NULL) ? -1 : 0;
}

/*----------------------------------------------------------------------*/

int EndParseFile(void)
{
    return feof(infile);
}

/*----------------------------------------------------------------------*/

int CloseParseFile(void)
{
    struct filestack *lastfile;
    int rval;
    rval = fclose(infile);
    infile = (FILE *)NULL;

    /* Pop filestack if not empty */
    lastfile = OpenFiles;
    if (lastfile != NULL) {
	OpenFiles = lastfile->next;
	infile = lastfile->file;
	free(lastfile);
    }
    return rval;
}

/*----------------------------------------------------------------------*/

void InputParseError(FILE *f)
{
    char *ch;

    fprintf(f, "line number %d = '", vlinenum);
    for (ch = line; *ch != '\0'; ch++) {
	if (isprint(*ch)) fprintf(f, "%c", *ch);
	else if (*ch != '\n') fprintf(f, "<<%d>>", (int)(*ch));
    }
    fprintf(f, "'\n");
}

/*----------------------------------------------------------------------*/
/* Tokenizer routines							*/
/*----------------------------------------------------------------------*/

#define WHITESPACE_DELIMITER " \t\n\r"

/*----------------------------------------------------------------------*/
/* TrimQuoted() ---                                                     */
/* Remove spaces from inside single- or double-quoted strings.          */
/*----------------------------------------------------------------------*/

void TrimQuoted(char *line)
{
    char *qstart, *qend, *lptr;
    int slen;
    int changed;

    /* Single-quoted entries */
    changed = TRUE;
    lptr = line;
    while (changed)
    {
	changed = FALSE;
	qstart = strchr(lptr, '\'');
	if (qstart)
	{
	    qend = strchr(qstart + 1, '\'');
	    if (qend && (qend > qstart)) {
		slen = strlen(lptr);
		for (lptr = qstart + 1; lptr < qend; lptr++) {
		    if (*lptr == ' ') {
			memmove(lptr, lptr + 1, slen);
			qend--;
			changed = TRUE;
		    }
		}
		lptr++;
	    }
	}
    }

    /* Double-quoted entries */
    changed = TRUE;
    lptr = line;
    while (changed)
    {
	changed = FALSE;
	qstart = strchr(lptr, '\"');
	if (qstart)
	{
	    qend = strchr(qstart + 1, '\"');
	    if (qend && (qend > qstart)) {
		slen = strlen(lptr);
		for (lptr = qstart + 1; lptr < qend; lptr++) {
		    if (*lptr == ' ') {
			memmove(lptr, lptr + 1, slen);
			qend--;
			changed = TRUE;
		    }
		}
		lptr++;
	    }
	}
    }
}

/*----------------------------------------------------------------------*/
/* GetNextLineNoNewline()                                               */
/*                                                                      */
/* Fetch the next line, and grab the first token from the next line.    */
/* If there is no next token (next line is empty, and ends with a       */
/* newline), then place NULL in nexttok.                                */
/*                                                                      */
/*----------------------------------------------------------------------*/

int GetNextLineNoNewline(char *delimiter)
{
    char *newbuf;
    int testc;

    if (feof(infile)) return -1;

    // This is more reliable than feof() ...
    testc = getc(infile);
    if (testc == -1) return -1;
    ungetc(testc, infile);

    if (linesize == 0) {
	/* Allocate memory for line */
	linesize = 500;
	line = (char *)malloc(linesize);
	linetok = (char *)malloc(linesize);
    }
    fgets(line, linesize, infile);
    while (strlen(line) == linesize - 1) {
	newbuf = (char *)malloc(linesize + 500);
	strcpy(newbuf, line);
	free(line);
	line = newbuf;
	fgets(line + linesize - 1, 501, infile);
	linesize += 500;
	free(linetok);
	linetok = (char *)malloc(linesize * sizeof(char));
    }
    vlinenum++;
    strcpy(linetok, line);
    TrimQuoted(linetok);

    nexttok = strdtok(linetok, WHITESPACE_DELIMITER, delimiter);
    return 0;
}

/*----------------------------------------------------------------------*/
/* Get the next line of input from file "infile", and find the first    */
/* valid token.                                                         */
/*----------------------------------------------------------------------*/

void GetNextLine(char *delimiter)
{
    do {
	if (GetNextLineNoNewline(delimiter) == -1) return;
    } while (nexttok == NULL);
}

/*----------------------------------------------------------------------*/
/* skip to the end of the current line                                  */
/*----------------------------------------------------------------------*/

void SkipNewLine(char *delimiter)
{
    while (nexttok != NULL)
	nexttok = strdtok(NULL, WHITESPACE_DELIMITER, delimiter);
}

/*----------------------------------------------------------------------*/
/* if nexttok is already NULL, force scanner to read new line           */
/*----------------------------------------------------------------------*/

void SkipTok(char *delimiter)
{
    if (nexttok != NULL &&
		(nexttok = strdtok(NULL, WHITESPACE_DELIMITER, delimiter)))
	return;
    GetNextLine(delimiter);
}

/*----------------------------------------------------------------------*/
/* like SkipTok, but will not fetch a new line when the buffer is empty */
/* must be preceeded by at least one call to SkipTok()                  */
/*----------------------------------------------------------------------*/

void SkipTokNoNewline(char *delimiter)
{
    nexttok = strdtok(NULL, WHITESPACE_DELIMITER, delimiter);
}

/*----------------------------------------------------------------------*/
/* Skip to the next token, ignoring any C-style comments.               */
/*----------------------------------------------------------------------*/

void SkipTokComments(char *delimiter)
{
    SkipTok(delimiter);
    while (nexttok) {
	if (!strcmp(nexttok, "//")) {
	    SkipNewLine(delimiter);
	    SkipTok(delimiter);
	}
	else if (!strcmp(nexttok, "/*")) {
	    while (nexttok && strcmp(nexttok, "*/"))
		SkipTok(delimiter);
	    if (nexttok) SkipTok(delimiter);
	}
	else if (!strcmp(nexttok, "(*")) {
	    while (nexttok && strcmp(nexttok, "*)"))
		SkipTok(delimiter);
	    if (nexttok) SkipTok(delimiter);
	}
	else break;
    }
}

/*----------------------------------------------------------------------*/
/* Free a bus structure in the hash table during cleanup		*/
/*----------------------------------------------------------------------*/

int freenet (struct hashlist *p)
{
    struct netrec *wb;

    wb = (struct netrec *)(p->ptr);
    free(wb);
    return 1;
}

/*----------------------------------------------------------------------*/
/* Create a new net (or bus) structure					*/
/*----------------------------------------------------------------------*/

struct netrec *NewNet()
{
    struct netrec *wb;

    wb = (struct netrec *)calloc(1, sizeof(struct netrec));
    if (wb == NULL) fprintf(stderr, "NewNet: Core allocation error\n");
    return (wb);
}

/*----------------------------------------------------------------------*/
/* BusHashLookup --							*/
/* Run HashLookup() on a string, first removing any bus delimiters.	*/
/*----------------------------------------------------------------------*/

void *BusHashLookup(char *s, struct hashtable *table)
{
    void *rval;
    char *dptr = NULL;
    char *sptr = s;

    if (*sptr == '\\') {
	sptr = strchr(s, ' ');
	if (sptr == NULL) sptr = s;
    }
    if ((dptr = strchr(sptr, '[')) != NULL) *dptr = '\0';

    rval = HashLookup(s, table);
    if (dptr) *dptr = '[';
    return rval;
}

/*----------------------------------------------------------------------*/
/* BusHashPtrInstall --							*/
/* Run HashPtrInstall() on a string, first removing any bus delimiters.	*/
/*----------------------------------------------------------------------*/

struct hashlist *BusHashPtrInstall(char *name, void *ptr,
                                struct hashtable *table)
{
    struct hashlist *rval;
    char *dptr = NULL;
    char *sptr = name;

    if (*sptr == '\\') {
	sptr = strchr(name, ' ');
	if (sptr == NULL) sptr = name;
    }
    if ((dptr = strchr(sptr, '[')) != NULL) *dptr = '\0';

    rval = HashPtrInstall(name, ptr, table);
    if (dptr) *dptr = '[';
    return rval;
}

/*------------------------------------------------------------------------------*/
/* Get bus indexes from the notation name[a:b].  If there is only "name"	*/
/* then look up the name in the bus hash list and return the index bounds.	*/
/* Return 0 on success, 1 on syntax error, and -1 if signal is not a bus.	*/
/*										*/
/* Note that this routine relies on the delimiter characters including		*/
/* "[", ":", and "]" when calling NextTok.					*/
/*------------------------------------------------------------------------------*/

int GetBusTok(struct netrec *wb, struct hashtable *nets)
{
    int result, start, end;
    char *kl;

    if (wb == NULL) return 0;
    else {
        wb->start = -1;
        wb->end = -1;
    }

    if (!strcmp(nexttok, "[")) {
	SkipTokComments(VLOG_DELIMITERS);

	// Check for parameter names and substitute values if found.
	if (nexttok[0] == '`') {
	    kl = (char *)HashLookup(nexttok + 1, &verilogdefs);
	    if (kl == NULL) {
		fprintf(stdout, "Unknown definition %s found in array "
			"notation (line %d).\n", nexttok, vlinenum);
		return 1;
	    }
	    else {
		result = sscanf(kl, "%d", &start);
		if (result != 1) {
		    fprintf(stdout, "Cannot parse first digit from parameter "
				"%s value %s (line %d)\n", nexttok, kl, vlinenum);
		    return 1;
		}
	    }
	}
	else {
	    result = sscanf(nexttok, "%d", &start);
	    if (result != 1) {
		// Is name in the parameter list?
	        kl = (char *)HashLookup(nexttok, &verilogparams);
		if (kl == NULL) {
		    fprintf(stdout, "Array value %s is not a number or a "
				"parameter (line %d).\n", nexttok, vlinenum);
		    return 1;
		}
		else {
		    result = sscanf(kl, "%d", &start);
		    if (result != 1) {
		        fprintf(stdout, "Parameter %s has value %s that cannot be parsed"
				" as an integer (line %d).\n", nexttok, kl, vlinenum);
			return 1;
		    }
		}
	    }
	}
	SkipTokComments(VLOG_DELIMITERS);
	if (!strcmp(nexttok, "]")) {
	    result = 1;
	    end = start;	// Single bit
	}
	else if (strcmp(nexttok, ":")) {
	    fprintf(stdout, "Badly formed array notation:  Expected colon, "
			"found %s (line %d)\n", nexttok, vlinenum);
	    return 1;
	}
	else {
	    SkipTokComments(VLOG_DELIMITERS);

	    // Check for parameter names and substitute values if found.
	    if (nexttok[0] == '`') {
		kl = (char *)HashLookup(nexttok + 1, &verilogdefs);
		if (kl == NULL) {
		    fprintf(stdout, "Unknown definition %s found in array "
				"notation (line %d).\n", nexttok, vlinenum);
		    return 1;
		}
		else {
		    result = sscanf(kl, "%d", &end);
		    if (result != 1) {
			fprintf(stdout, "Cannot parse second digit from parameter "
					"%s value %s (line %d)\n", nexttok, kl,
					vlinenum);
			return 1;
		    }
		}
	    }
	    else {
		result = sscanf(nexttok, "%d", &end);
		if (result != 1) {
		    // Is name in the parameter list?
	            kl = (char *)HashLookup(nexttok, &verilogparams);
		    if (kl == NULL) {
			fprintf(stdout, "Array value %s is not a number or a "
					"parameter (line %d).\n", nexttok, vlinenum);
			return 1;
		    }
		    else {
			result = sscanf(kl, "%d", &end);
			if (result != 1) {
		            fprintf(stdout, "Parameter %s has value %s that cannot"
					" be parsed as an integer (line %d).\n",
					nexttok, kl, vlinenum);
			    return 1;
			}
		    }
		}
	    }
	}
	wb->start = start;
	wb->end = end;

	while (strcmp(nexttok, "]")) {
	    SkipTokComments(VLOG_DELIMITERS);
	    if (nexttok == NULL) {
		fprintf(stdout, "End of file reached while reading array bounds.\n");
		return 1;
	    }
	    else if (!strcmp(nexttok, ";")) {
		// Better than reading to end-of-file, give up on end-of-statement
		fprintf(stdout, "End of statement reached while reading "
				"array bounds (line %d).\n", vlinenum);
		return 1;
	    }
	}
	/* Move token forward to bus name */
	SkipTokComments(VLOG_DELIMITERS);
    }
    else if (nets) {
	struct netrec *hbus;
	hbus = (struct netrec *)BusHashLookup(nexttok, nets);
	if (hbus != NULL) {
	    wb->start = hbus->start;
	    wb->end = hbus->end;
	}
	else
	    return -1;
    }
    return 0;
}

/*----------------------------------------------------------------------*/
/* GetBus() is similar to GetBusTok() (see above), but it parses from	*/
/* a string instead of the input tokenizer.				*/
/*----------------------------------------------------------------------*/

int GetBus(char *astr, struct netrec *wb, struct hashtable *nets)
{
    char *colonptr, *brackstart, *brackend, *sstr;
    int result, start, end;

    if (wb == NULL) return 0;
    else {
        wb->start = -1;
        wb->end = -1;
    }
    sstr = astr;

    // Skip to the end of verilog names bounded by '\' and ' '
    if (*sstr == '\\')
	while (*sstr && *sstr != ' ') sstr++;

    brackstart = strchr(sstr, '[');
    if (brackstart != NULL) {
	brackend = strchr(sstr, ']');
	if (brackend == NULL) {
	    fprintf(stdout, "Badly formed array notation \"%s\" (line %d)\n", astr,
			vlinenum);
	    return 1;
	}
	*brackend = '\0';
	colonptr = strchr(sstr, ':');
	if (colonptr) *colonptr = '\0';
	result = sscanf(brackstart + 1, "%d", &start);
	if (colonptr) *colonptr = ':';
	if (result != 1) {
	    fprintf(stdout, "Badly formed array notation \"%s\" (line %d)\n", astr,
			vlinenum);
	    *brackend = ']';
	    return 1;
	}
	if (colonptr)
	    result = sscanf(colonptr + 1, "%d", &end);
	else {
	    result = 1;
	    end = start;        // Single bit
	}
	*brackend = ']';
	if (result != 1) {
	    fprintf(stdout, "Badly formed array notation \"%s\" (line %d)\n", astr,
			vlinenum);
	    return 1;
	}
	wb->start = start;
	wb->end = end;
    }
    else if (nets) {
	struct netrec *hbus;
	hbus = (struct netrec *)BusHashLookup(astr, nets);
	if (hbus != NULL) {
	    wb->start = hbus->start;
	    wb->end = hbus->end;
	}
	else
	    return -1;
    }
    return 0;
}

/*------------------------------------------------------*/
/* Add net to cell database				*/
/*------------------------------------------------------*/

struct netrec *Net(struct cellrec *cell, char *netname)
{
    struct netrec *newnet;

    newnet = NewNet();
    newnet->start = -1;
    newnet->end = -1;

    /* Install net in net hash */
    BusHashPtrInstall(netname, newnet, &cell->nets);

    return newnet;
}

/*------------------------------------------------------*/
/* Add port to instance record				*/
/*------------------------------------------------------*/

struct portrec *InstPort(struct instance *inst, char *portname, char *netname)
{
    struct portrec *portsrch, *newport;

    newport = (struct portrec *)malloc(sizeof(struct portrec));
    newport->name = strdup(portname);
    newport->direction = PORT_NONE;
    if (netname)
	newport->net = strdup(netname);
    else
	newport->net = NULL;
    newport->next = NULL; 

    /* Go to end of the port list */
    if (inst->portlist == NULL) {
	inst->portlist = newport;
    }
    else {
	for (portsrch = inst->portlist; portsrch->next; portsrch = portsrch->next);
 	portsrch->next = newport;
    }
    return newport;
}

/*------------------------------------------------------*/
/* Add port to cell database				*/
/*------------------------------------------------------*/

void Port(struct cellrec *cell, char *portname, struct netrec *net, int port_type)
{
    struct portrec *portsrch, *newport;
    struct netrec *newnet;

    newport = (struct portrec *)malloc(sizeof(struct portrec));
    if (portname)
	newport->name = strdup(portname);
    else
	newport->name = NULL;
    newport->direction = port_type;
    newport->net = NULL;
    newport->next = NULL; 

    /* Go to end of the port list */
    if (cell->portlist == NULL) {
	cell->portlist = newport;
    }
    else {
	for (portsrch = cell->portlist; portsrch->next; portsrch = portsrch->next);
 	portsrch->next = newport;
    }

    /* Register the port name as a net in the cell */
    if (portname)
    {
	newnet = Net(cell, portname);
	if (net) {
	    newnet->start = net->start;
	    newnet->end = net->end;
	}
    }
}

/*------------------------------------------------------*/
/* Create a new cell					*/
/*------------------------------------------------------*/

struct cellrec *Cell(char *cellname)
{
    struct cellrec *new_cell;

    new_cell = (struct cellrec *)malloc(sizeof(struct cellrec));
    new_cell->name = strdup(cellname);
    new_cell->portlist = NULL;
    new_cell->instlist = NULL;
    new_cell->lastinst = NULL;

    InitializeHashTable(&new_cell->nets, LARGEHASHSIZE);
    InitializeHashTable(&new_cell->propdict, TINYHASHSIZE);

    return new_cell;
}

/*------------------------------------------------------*/
/* Add instance to cell database			*/
/*------------------------------------------------------*/

struct instance *Instance(struct cellrec *cell, char *cellname, int prepend)
{
    struct instance *newinst, *instsrch;

    /* Create new instance record */
    newinst = (struct instance *)malloc(sizeof(struct instance));

    newinst->instname = NULL;
    newinst->cellname = strdup(cellname);
    newinst->portlist = NULL;
    newinst->next = NULL;

    InitializeHashTable(&newinst->propdict, TINYHASHSIZE);
	
    if (cell->instlist == NULL) {
	cell->instlist = newinst;
    }
    else {
	if (prepend == TRUE) {
	    newinst->next = cell->instlist;
	    cell->instlist = newinst;
	}
	else {
	    instsrch = (cell->lastinst != NULL) ?
			cell->lastinst : cell->instlist;

	    /* Go to end of the instance list */
	    for (; instsrch->next; instsrch = instsrch->next);
		
	    cell->lastinst = instsrch;
 	    instsrch->next = newinst;
	}
    }
    return newinst;
}

struct instance *AppendInstance(struct cellrec *cell, char *cellname)
{
    return Instance(cell, cellname, FALSE);
}

struct instance *PrependInstance(struct cellrec *cell, char *cellname)
{
    return Instance(cell, cellname, TRUE);
}

/*------------------------------------------------------*/
/* Read a verilog structural netlist			*/
/*------------------------------------------------------*/

void ReadVerilogFile(char *fname, struct cellstack **CellStackPtr,
			int blackbox)
{
    int i;
    int warnings = 0, hasports, inlined_decls = 0, localcount = 1;
    int port_type = PORT_NONE;
    char in_module, in_param;
    char *eqptr;
    char pkey[256];

    struct cellrec *top = NULL;

    in_module = (char)0;
    in_param = (char)0;
  
    while (!EndParseFile()) {

	SkipTokComments(VLOG_DELIMITERS); /* get the next token */

	/* Diagnostic */
	/* if (nexttok) fprintf(stdout, "Token is \"%s\"\n", nexttok); */

	if ((EndParseFile()) && (nexttok == NULL)) break;
	else if (nexttok == NULL)
	    break;

	/* Ignore end-of-statement markers */
	else if (!strcmp(nexttok, ";"))
	    continue;

	/* Ignore primitive definitions */
	else if (!strcmp(nexttok, "primitive")) {
	    while (1) {
		SkipNewLine(VLOG_DELIMITERS);
		SkipTokComments(VLOG_DELIMITERS);
		if (EndParseFile()) break;
		if (!strcmp(nexttok, "endprimitive")) {
		    in_module = 0;
		    break;
		}
	    }
	}

	else if (!strcmp(nexttok, "module")) {
	    struct netrec wb;

	    SkipTokNoNewline(VLOG_DELIMITERS);
	    if (nexttok == NULL) {
		fprintf(stderr, "Badly formed \"module\" line (line %d)\n", vlinenum);
		goto skip_endmodule;
	    }

	    if (in_module == (char)1) {
		fprintf(stderr, "Missing \"endmodule\" statement on "
				"subcircuit (line %d).\n", vlinenum);
		InputParseError(stderr);
	    }
	    in_module = (char)1;
	    hasports = (char)0;
	    inlined_decls = (char)0;

	    /* If there is an existing module, then push it */
	    if (top != NULL) PushStack(top, CellStackPtr);

	    /* Create new cell */
	    top = Cell(nexttok);

	    /* Need to support both types of I/O lists:  Those	*/
	    /* that declare names only in the module list and	*/
	    /* follow with input/output and vector size		*/
	    /* declarations as individual statements in the	*/
	    /* module definition, and those which declare	*/
	    /* everything inside the pin list.			*/

            SkipTokComments(VLOG_DELIMITERS);

	    // Check for parameters within #( ... ) 

	    if (!strcmp(nexttok, "#(")) {
		SkipTokComments(VLOG_DELIMITERS);
		in_param = (char)1;
	    }
	    else if (!strcmp(nexttok, "(")) {
		SkipTokComments(VLOG_DELIMITERS);
	    }

	    wb.start = wb.end = -1;
            while ((nexttok != NULL) && strcmp(nexttok, ";")) {
		if (in_param) {
		    if (!strcmp(nexttok, ")")) {
			in_param = (char)0;
			SkipTokComments(VLOG_DELIMITERS);
			if (strcmp(nexttok, "(")) {
			    fprintf(stderr, "Badly formed module block parameter"
						" list (line %d).\n", vlinenum);
			    goto skip_endmodule;
			}
		    }
		    else if (!strcmp(nexttok, "=")) {

			// The parameter value is the next token.
			SkipTokComments(VLOG_DELIMITERS); /* get the next token */
			HashPtrInstall(pkey, strdup(nexttok), &top->propdict);
		    }
		    else {
			/* Assume this is a keyword and save it */
			strcpy(pkey, nexttok);
		    }
		}
		else if (strcmp(nexttok, ",")) {
		    if (!strcmp(nexttok, ")")) break;
		    // Ignore input, output, and inout keywords, and handle buses.

		    if (inlined_decls == (char)0) {
			if (!strcmp(nexttok, "input") || !strcmp(nexttok, "output")
				|| !strcmp(nexttok, "inout"))
			    inlined_decls = (char)1;
		    }

		    if (inlined_decls == (char)1) {
			if (!strcmp(nexttok, "input"))
			    port_type = PORT_INPUT;
			else if (!strcmp(nexttok, "output"))
			    port_type = PORT_OUTPUT;
			else if (!strcmp(nexttok, "inout"))
			    port_type = PORT_INOUT;
			else if (strcmp(nexttok, "real") && strcmp(nexttok, "logic")
					&& strcmp(nexttok, "integer")) {
			    if (!strcmp(nexttok, "[")) {
				if (GetBusTok(&wb, &top->nets) != 0) {
				    // Didn't parse as a bus, so wing it
				    Port(top, nexttok, NULL, port_type);
				}
				else
				    Port(top, nexttok, &wb, port_type);
			    }
			    else
				Port(top, nexttok, NULL, port_type);

			    hasports = 1;
			}
		    }
		}
		SkipTokComments(VLOG_DELIMITERS);
		if (nexttok == NULL) break;
	    }
	    if (inlined_decls == 1) {
		if (hasports == 0)
		    // If the cell defines no ports, then create a proxy
		    Port(top, (char *)NULL, NULL, PORT_NONE);

		/* In the blackbox case, don't read the cell contents */
		if (blackbox) goto skip_endmodule;
	    }
	}
	else if (!strcmp(nexttok, "input") || !strcmp(nexttok, "output")
			|| !strcmp(nexttok, "inout")) {
	    struct netrec wb;

	    if (!strcmp(nexttok, "input")) port_type = PORT_INPUT;
	    else if (!strcmp(nexttok, "output")) port_type = PORT_OUTPUT;
	    else if (!strcmp(nexttok, "inout")) port_type = PORT_INOUT;
	    else port_type = PORT_NONE;
 
	    // Parsing of ports as statements not in the module pin list.
	    wb.start = wb.end = -1;
	    while (1) {
		SkipTokComments(VLOG_DELIMITERS);
		if (EndParseFile()) break;

		if (!strcmp(nexttok, ";")) {
		    // End of statement
		    break;
		}
		else if (!strcmp(nexttok, "[")) {
		    if (GetBusTok(&wb, &top->nets) != 0) {
			// Didn't parse as a bus, so wing it
			Port(top, nexttok, NULL, port_type);
		    }
		    else
			Port(top, nexttok, &wb, port_type);
		}
		else if (strcmp(nexttok, ",")) {
		    /* Comma-separated list;  use same bus limits */
		    Port(top, nexttok, &wb, port_type);
		}
		hasports = 1;
	    }
	}
	else if (!strcmp(nexttok, "endmodule")) {

	    if (in_module == (char)0) {
		fprintf(stderr, "\"endmodule\" occurred outside of a "
				"module (line %d)!\n", vlinenum);
	        InputParseError(stderr);
	    }
	    in_module = (char)0;
	    SkipNewLine(VLOG_DELIMITERS);
	}
	else if (!strcmp(nexttok, "`include")) {
	    char *iname, *iptr, *quotptr, *pathend, *userpath = NULL;

	    SkipTokNoNewline(VLOG_DELIMITERS);
	    if (nexttok == NULL) continue;	/* Ignore if no filename */

	    // Any file included in another Verilog file needs to be
	    // interpreted relative to the path of the parent Verilog file,
	    // unless it's an absolute pathname.

	    pathend = strrchr(fname, '/');
	    iptr = nexttok;
	    while (*iptr == '\'' || *iptr == '\"') iptr++;
	    if ((pathend != NULL) && (*iptr != '/') && (*iptr != '~')) {
		*pathend = '\0';
		iname = (char *)malloc(strlen(fname) + strlen(iptr) + 2);
		sprintf(iname, "%s/%s", fname, iptr);
		*pathend = '/';
	    }
	    else if ((*iptr == '~') && (*(iptr + 1) == '/')) {
		/* For ~/<path>, substitute tilde from $HOME */
		userpath = getenv("HOME");
		iname = (char *)malloc(strlen(userpath) + strlen(iptr));
		sprintf(iname, "%s%s", userpath, iptr + 1);
	    }
	    else if (*iptr == '~') {
		/* For ~<user>/<path>, substitute tilde from getpwnam() */
		struct passwd *passwd;
		char *pathstart;
		pathstart = strchr(iptr, '/');
		if (pathstart) *pathstart = '\0';
		passwd = getpwnam(iptr + 1);
		if (passwd != NULL) {
		    userpath = passwd->pw_dir;
		    if (pathstart) {
			*pathstart = '/';
			iname = (char *)malloc(strlen(userpath) + strlen(pathstart) + 1);
			sprintf(iname, "%s%s", userpath, pathstart);
		    }
		    else {
			/* Almost certainly an error, but make the substitution anyway */
			iname = strdup(userpath);
		    }
		}
		else {
		    /* Probably an error, but copy the filename verbatim */
		    iname = strdup(iptr);
		}
	    }
	    else
		iname = strdup(iptr);

	    // Eliminate any single or double quotes around the filename
	    iptr = iname;
	    quotptr = iptr;
	    while (*quotptr != '\'' && *quotptr != '\"' && 
			*quotptr != '\0' && *quotptr != '\n') quotptr++;
	    if (*quotptr == '\'' || *quotptr == '\"') *quotptr = '\0';
	
	    IncludeVerilog(iptr, CellStackPtr, blackbox);
	    free(iname);
	    SkipNewLine(VLOG_DELIMITERS);
	}
	else if (!strcmp(nexttok, "`define")) {
	    char *key;

	    /* Parse for definitions used in expressions.  Save	*/
	    /* definitions in the "verilogdefs" hash table.	*/

	    SkipTokNoNewline(VLOG_DELIMITERS);
	    if ((nexttok == NULL) || (nexttok[0] == '\0')) break;

	    key = strdup(nexttok);

	    SkipTokNoNewline(VLOG_DELIMITERS);
	    if ((nexttok == NULL) || (nexttok[0] == '\0'))
		/* Let "`define X" be equivalent to "`define X 1". */
		HashPtrInstall(key, strdup("1"), &verilogdefs);
	    else	 
		HashPtrInstall(key, strdup(nexttok), &verilogdefs);
	}
	else if (!strcmp(nexttok, "localparam")) {
	    // Pick up key = value pairs and store in current cell
	    while (nexttok != NULL)
	    {
		/* Parse for parameters used in expressions.  Save	*/
		/* parameters in the "verilogparams" hash table.	*/

		SkipTokNoNewline(VLOG_DELIMITERS);
		if ((nexttok == NULL) || (nexttok[0] == '\0')) break;
		if ((eqptr = strchr(nexttok, '=')) != NULL) {
		    *eqptr = '\0';
		    HashPtrInstall(nexttok, strdup(eqptr + 1), &verilogparams);
		}
	    }
	}

	/* Note:  This is just the most basic processing of conditionals,	*/
	/* although it does handle nested conditionals.				*/
    
	else if (!strcmp(nexttok, "`ifdef") || !strcmp(nexttok, "`ifndef")) {
	    char *kl;
	    int nested = 0;
            int invert = (nexttok[3] == 'n') ? 1 : 0;

	    SkipTokNoNewline(VLOG_DELIMITERS);

	    /* To be done:  Handle boolean arithmetic on conditionals */

	    kl = (char *)HashLookup(nexttok, &verilogdefs);
	    if (((invert == 0) && (kl == NULL))
			|| ((invert == 1) && (kl != NULL))) {
		/* Skip to matching `endif */
		while (1) {
		    SkipNewLine(VLOG_DELIMITERS);
		    SkipTokComments(VLOG_DELIMITERS);
		    if (EndParseFile()) break;
		    if (!strcmp(nexttok, "`ifdef") || !strcmp(nexttok, "`ifndef")) {
			nested++;
		    }
		    else if (!strcmp(nexttok, "`endif")) {
			if (nested == 0)
			    break;
			else
			    nested--;
		    }
		}
	    }
	}

	else if (!strcmp(nexttok, "wire") ||
		 !strcmp(nexttok, "assign")) {	/* wire = node */
	    struct netrec wb, *nb;
	    char *eptr, *wirename;
	    char is_assignment = FALSE;

	    // Several allowed uses of "assign":
	    // "assign a = b" joins two nets.
	    // "assign a = {b, c, ...}" creates a bus from components.
	    // "assign" using any boolean arithmetic is not structural verilog.

	    SkipTokNoNewline(VLOG_DELIMITERS);
	    if (!strcmp(nexttok, "real")) SkipTokNoNewline(VLOG_DELIMITERS);
	    while (nexttok != NULL) {
		if (!strcmp(nexttok, "=")) {
		    is_assignment = TRUE;
		}
		else if (GetBusTok(&wb, &top->nets) == 0) {
		    /* Handle bus notation */
		    if ((nb = BusHashLookup(nexttok, &top->nets)) == NULL)
			nb = Net(top, nexttok);
		    if (nb->start == -1) {
		        nb->start = wb.start;
		        nb->end = wb.end;
		    }
		    else {
			if (nb->start < wb.start) nb->start = wb.start;
			if (nb->end > wb.end) nb->end = wb.end;
		    }
		}
		else {
		    if (is_assignment) {
			if (BusHashLookup(nexttok, &top->nets) != NULL) {
			    /* Join nets */
			    /* (WIP) */
			}
			else if (*nexttok == '1' && *(nexttok + 1) == '\'' &&
			    (*(nexttok + 3) == '1' || *(nexttok + 3) == '0')) {
			
			    // Power/Ground denoted by, e.g., "vdd = 1'b1".
			    // Only need to record the net, no further action
			    // needed.
			}
			else {
			    fprintf(stdout, "Assignment is not a net (line %d).\n",
					vlinenum);
			    fprintf(stdout, "Module '%s' is not structural verilog,"
					" making black-box.\n", top->name);
			    goto skip_endmodule;
			}
			is_assignment = FALSE;
		    }
		    else if (BusHashLookup(nexttok, &top->nets) == NULL)
			Net(top, nexttok);
		}
		do {
		    SkipTokNoNewline(VLOG_DELIMITERS);
		} while (nexttok && !strcmp(nexttok, ";"));
	    }
	}
	else if (!strcmp(nexttok, "endmodule")) {
	    // No action---new module is started with next 'module' statement,
	    // if any.
	    SkipNewLine(VLOG_DELIMITERS);
	}
	else if (nexttok[0] == '`') {
	    // Ignore any other directive starting with a backtick
	    SkipNewLine(VLOG_DELIMITERS);
	}
	else if (!strcmp(nexttok, "reg") || !strcmp(nexttok, "always")) {
	    fprintf(stdout, "Module '%s' is not structural verilog, making "
			"black-box.\n", top->name);
	    goto skip_endmodule;
	}
	else {	/* module instances */
	    int itype, arraymax, arraymin;
	    struct instance *thisinst;

	    thisinst = AppendInstance(top, nexttok);

	    SkipTokComments(VLOG_DELIMITERS);

	    // Next token must be '#(' (parameters) or an instance name

	    if (!strcmp(nexttok, "#(")) {

		// Read the parameter list
		SkipTokComments(VLOG_DELIMITERS);

		while (nexttok != NULL) {
		    char *paramname;

		    if (!strcmp(nexttok, ")")) {
			SkipTokComments(VLOG_DELIMITERS);
			break;
		    }
		    else if (!strcmp(nexttok, ",")) {
			SkipTokComments(VLOG_DELIMITERS);
			continue;
		    }

		    // We need to look for parameters of the type ".name(value)"

		    else if (nexttok[0] == '.') {
			paramname = strdup(nexttok + 1);
			SkipTokComments(VLOG_DELIMITERS);
			if (strcmp(nexttok, "(")) {
			    fprintf(stdout, "Error: Expecting parameter value, "
					"got %s (line %d).\n", nexttok, vlinenum);
			}
			SkipTokComments(VLOG_DELIMITERS);
			if (!strcmp(nexttok, ")")) {
			    fprintf(stdout, "Error: Parameter with no value found"
					" (line %d).\n", vlinenum);
			}
			else {
			    HashPtrInstall(paramname, strdup(nexttok),
					&thisinst->propdict); 
			    SkipTokComments(VLOG_DELIMITERS);
			    if (strcmp(nexttok, ")")) {
				fprintf(stdout, "Error: Expecting end of parameter "
					"value, got %s (line %d).\n", nexttok,
					vlinenum);
			    }
			}
			free(paramname);
		    }
		    SkipTokComments(VLOG_DELIMITERS);
		}
		if (!nexttok) {
		    fprintf(stdout, "Error: Still reading module, but got "
				"end-of-file.\n");
		    goto skip_endmodule;
		}
	    }

	    thisinst->instname = strdup(nexttok);

	    /* fprintf(stdout, "Diagnostic:  new instance is %s\n",	*/
	    /*			thisinst->instname);			*/
	    SkipTokComments(VLOG_DELIMITERS);

	    thisinst->arraystart = thisinst->arrayend = -1;
	    if (!strcmp(nexttok, "[")) {
		// Handle instance array notation.
		struct netrec wb;
		if (GetBusTok(&wb, NULL) == 0) {
		    thisinst->arraystart = wb.start;
		    thisinst->arrayend = wb.end;
		}
	    }

	    if (!strcmp(nexttok, "(")) {
		char savetok = (char)0;
		struct portrec *new_port;
		struct netrec *nb, wb;
		char in_line = FALSE, *in_line_net = NULL;
		char *ncomp, *nptr;

		// Read the pin list
		while (nexttok != NULL) {
		    SkipTokComments(VLOG_DELIMITERS);
		    // NOTE: Deal with `ifdef et al. properly.  Ignoring for now.
		    while (nexttok[0] == '`') {
			SkipNewLine(VLOG_DELIMITERS);
			SkipTokComments(VLOG_DELIMITERS);
		    }
		    if (!strcmp(nexttok, ")")) break;
		    else if (!strcmp(nexttok, ",")) continue;

		    // We need to look for pins of the type ".name(value)"

		    if (nexttok[0] != '.') {
			fprintf(stdout, "Badly formed subcircuit pin "
				"line at \"%s\" (line %d)\n",
				nexttok, vlinenum);
			SkipNewLine(VLOG_DELIMITERS);
		    }
		    else {
			new_port = InstPort(thisinst, strdup(nexttok + 1), NULL);
			SkipTokComments(VLOG_DELIMITERS);
			if (strcmp(nexttok, "(")) {
			    fprintf(stdout, "Badly formed subcircuit pin line "
					"at \"%s\" (line %d)\n", nexttok, vlinenum);
			    SkipNewLine(VLOG_DELIMITERS);
			}
			SkipTokComments(VLOG_PIN_CHECK_DELIMITERS);
			if (!strcmp(nexttok, ")")) {
			    char localnet[100];
			    // Empty parens, so create a new local node
			    savetok = (char)1;
			    sprintf(localnet, "_noconnect_%d_", localcount++);
			    new_port->net = strdup(localnet);
			}
			else {

			    if (!strcmp(nexttok, "{")) {
				char *in_line_net = (char *)malloc(1);
				*in_line_net = '\0';
				/* In-line array---Read to "}" */
				while (nexttok) {
				    in_line_net = (char *)realloc(in_line_net,
						strlen(in_line_net) +
						strlen(nexttok) + 1);
				    strcat(in_line_net, nexttok);
				    if (!strcmp(nexttok, "}")) break;
				    SkipTokComments(VLOG_PIN_CHECK_DELIMITERS);
				}
				if (!nexttok) {
				    fprintf(stderr, "Unterminated net in pin %s "
						"(line %d)\n", in_line_net,
						vlinenum);
				}
				new_port->net = in_line_net;
			    }
			    else
				new_port->net = strdup(nexttok);

			    /* Read array information along with name;	*/
			    /* will be parsed later 			*/

			    SkipTokComments(VLOG_DELIMITERS);
			    if (!strcmp(nexttok, "[")) {
				/* Check for space between name and array identifier */
				SkipTokComments(VLOG_PIN_NAME_DELIMITERS);
				if (strcmp(nexttok, ")")) {
				    char *expnet;
				    expnet = (char *)malloc(strlen(new_port->net)
						+ strlen(nexttok) + 3);
				    sprintf(expnet, "%s [%s", new_port->net, nexttok);
				    free(new_port->net);
				    new_port->net = expnet;
				}
				SkipTokComments(VLOG_DELIMITERS);
			    }
			    if (strcmp(nexttok, ")")) {
				fprintf(stdout, "Badly formed subcircuit pin line "
					"at \"%s\" (line %d)\n", nexttok, vlinenum);
				SkipNewLine(VLOG_DELIMITERS);
			    }
			}

			/* Register wire if it has not been already, and if it	*/
			/* has been registered, check if this wire increases	*/
			/* the net bounds.  If the net name is an in-line	*/
			/* vector, then process each component separately.	*/

			ncomp = new_port->net;
			while (isdigit(*ncomp)) ncomp++;
			if (*ncomp == '{') ncomp++;
			while (isspace(*ncomp)) ncomp++;
			while (*ncomp != '\0') {
			    int is_esc = FALSE;
			    char saveptr;

			    /* NOTE:  This follows same rules in strdtok() */
			    nptr = ncomp;
			    if (*nptr == '\\') is_esc = TRUE;
			    while (*nptr != ',' && *nptr != '}' && *nptr != '\0') {
				if (*nptr == ' ') {
				    if (is_esc == TRUE)
					is_esc = FALSE;
				    else
					break;
				}
				nptr++;
			    }
			    saveptr = *nptr;
			    *nptr = '\0';

			    /* Parse ncomp as a net or bus */
			    if ((nb = BusHashLookup(ncomp, &top->nets)) == NULL)
				nb = Net(top, ncomp);

			    GetBus(ncomp, &wb, &top->nets);
			    if (nb->start == -1) {
				nb->start = wb.start;
				nb->end = wb.end;
			    }
			    else {
				if (nb->start < wb.start) nb->start = wb.start;
				if (nb->end > wb.end) nb->end = wb.end;
			    }

			    *nptr = saveptr;
			    if (*new_port->net != '{')
				break;

			    ncomp = nptr + 1;
			    /* Skip over any whitespace at the end of a name */
			    while ((*ncomp != '\0') && (*ncomp == ' '))
				ncomp++;
			    while ((*ncomp != '\0') && (*nptr == ',' || *nptr == '}'))
				ncomp++;
			}
		    }
		}
	    }
	    else {
		fprintf(stdout, "Expected to find instance pin block but got "
				"\"%s\" (line %d)\n", nexttok, vlinenum);
	    }

	    /* Instance should end with a semicolon */
	    SkipTokComments(VLOG_DELIMITERS);
	    if (strcmp(nexttok, ";")) {
		fprintf(stdout, "Expected to find end of instance but got "
				"\"%s\" (line %d)\n", nexttok, vlinenum);
	    }
	}
	continue;

skip_endmodule:
	/* There was an error, so skip to the end of the	*/
	/* subcircuit definition				*/

	while (1) {
	    SkipNewLine(VLOG_DELIMITERS);
	    SkipTokComments(VLOG_DELIMITERS);
	    if (EndParseFile()) break;
	    if (!strcmp(nexttok, "endmodule")) {
		in_module = 0;
		break;
	    }
	}
	continue;

baddevice:
	fprintf(stderr, "Badly formed line in input (line %d).\n", vlinenum);
    }

    /* Watch for bad ending syntax */

    if (in_module == (char)1) {
	fprintf(stderr, "Missing \"endmodule\" statement in module.\n");
	InputParseError(stderr);
    }

    /* Make sure topmost cell is on stack before returning */
    PushStack(top, CellStackPtr);

    if (warnings)
	fprintf(stderr, "File %s read with %d warning%s.\n", fname,
		warnings, (warnings == 1) ? "" : "s");
}

/*----------------------------------------------*/
/* Free memory associated with a cell		*/
/*----------------------------------------------*/

/*----------------------------------------------*/
/* Free memory associated with property hash	*/
/*----------------------------------------------*/

int freeprop(struct hashlist *p)
{
    char *propval;

    propval = (char *)(p->ptr);
    free(propval);
    return 1;
}

/*----------------------------------------------*/
/* Top-level verilog module file read routine	*/
/*----------------------------------------------*/

struct cellrec *ReadVerilogTop(char *fname, int blackbox)
{
    struct cellstack *CellStackPtr = NULL;
    struct cellrec *top;
  
    if ((OpenParseFile(fname)) < 0) {
	fprintf(stderr, "Error in Verilog file read: No file %s\n", fname);
	return NULL;
    }

    InitializeHashTable(&verilogparams, TINYHASHSIZE);
    InitializeHashTable(&verilogdefs, TINYHASHSIZE);
    InitializeHashTable(&verilogvectors, TINYHASHSIZE);

    ReadVerilogFile(fname, &CellStackPtr, blackbox);
    CloseParseFile();

    RecurseHashTable(&verilogparams, freeprop);
    HashKill(&verilogparams);
    RecurseHashTable(&verilogdefs, freeprop);
    HashKill(&verilogdefs);

    if (CellStackPtr == NULL) return NULL;

    top = CellStackPtr->cell;
    free(CellStackPtr);
    return top;
}

/*--------------------------------------*/
/* Wrappers for ReadVerilogTop()	*/
/*--------------------------------------*/

struct cellrec *ReadVerilog(char *fname)
{
    return ReadVerilogTop(fname, 0);
}

/*--------------------------------------*/
/* Verilog file include routine		*/
/*--------------------------------------*/

void IncludeVerilog(char *fname, struct cellstack **CellStackPtr, int blackbox)
{
    int filenum = -1;
    char name[256];

    name[0] = '\0';

    /* If fname does not begin with "/", then assume that it is	*/
    /* in the same relative path as its parent.			*/
  
    if (fname[0] != '/') {
	char *ppath;
	if (*CellStackPtr && ((*CellStackPtr)->cell != NULL)) {
	    strcpy(name, (*CellStackPtr)->cell->name);
	    ppath = strrchr(name, '/');
	    if (ppath != NULL)
		strcpy(ppath + 1, fname);
	    else
		strcpy(name, fname);
	    filenum = OpenParseFile(name);
	}
    }

    /* If we failed the path relative to the parent, then try 	*/
    /* the filename alone (relative to the path where netgen	*/
    /* was executed).						*/

    if (filenum < 0) {
	if ((filenum = OpenParseFile(fname)) < 0) {
	    if (filenum < 0) {
		fprintf(stderr,"Error in Verilog file include: No file %s\n",
			    (*name == '\0') ? fname : name);
		return;
	    }    
	}
    }
    ReadVerilogFile(fname, CellStackPtr, blackbox);
    CloseParseFile();
}

/*------------------------------------------------------*/
/* Free the cellrec structure created by ReadVerilog()	*/
/*------------------------------------------------------*/

void FreeVerilog(struct cellrec *topcell)
{
    struct portrec *port, *dport;
    struct instance *inst, *dinst;

    port = topcell->portlist;
    while (port) {
	if (port->name) free(port->name);
	if (port->net) free(port->net);
	dport = port->next;
	free(port);
	port = dport;
    }
    inst = topcell->instlist;
    while (inst) {
	if (inst->instname) free(inst->instname);
	if (inst->cellname) free(inst->cellname);
	port = inst->portlist;
	while (port) {
	    if (port->name) free(port->name);
	    if (port->net) free(port->net);
	    dport = port->next;
	    free(port);
	    port = dport;
	}
        RecurseHashTable(&inst->propdict, freeprop);
        HashKill(&inst->propdict);
	dinst = inst->next;
	free(inst);
	inst = dinst;
    }

    /* Delete nets hashtable */
    RecurseHashTable(&topcell->nets, freenet);
    HashKill(&topcell->nets);

    /* Delete properties hashtable. */
    RecurseHashTable(&topcell->propdict, freeprop);
    HashKill(&topcell->propdict);
}


// readverilog.c
