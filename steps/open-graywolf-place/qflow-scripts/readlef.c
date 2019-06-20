/*
 * lef.c --      
 *
 * This module incorporates the LEF/DEF format for standard-cell routing
 * route.
 *
 * Version 0.1 (September 26, 2003):  LEF input handling.  Includes creation
 * of cells from macro statements, handling of pins, ports, obstructions, and
 * associated geometry.
 *
 * Written by Tim Edwards, Open Circuit Design
 * Modified June 2011 for use with qrouter.
 * Modified November 2018 for use with qflow.
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <stdarg.h>
#include <sys/time.h>
#include <math.h>

#include "hash.h"
#include "readlef.h"

/*----------------------------------------------------------------------*/
/* Global variables							*/
/*----------------------------------------------------------------------*/

GATE   GateInfo = NULL;		// standard cell macro information
u_char Verbose = 0;
char   delimiter;		// opening bus delimiter;

struct hashtable MacroTable;

/*----------------------------------------------------------------------*/

/* Current line number for reading */
int lefCurrentLine = 0;

/* Information about routing layers */
LefList LefInfo = NULL;

/* Information about what vias to use */
LinkedStringPtr AllowedVias = NULL;

/* Gate information is in the linked list GateInfo, imported */

/*
 *---------------------------------------------------------
 * Initialize hash table of cells
 *---------------------------------------------------------
 */

static void
LefHashInit(void)
{
    /* Initialize the macro hash table */
    InitializeHashTable(&MacroTable, SMALLHASHSIZE);
}

/*
 *---------------------------------------------------------
 * Add macro to Lef cell macro hash table
 *---------------------------------------------------------
 */

static void
LefHashMacro(GATE gateginfo)
{
    HashPtrInstall(gateginfo->gatename, gateginfo, &MacroTable);
}

/*---------------------------------------------------------
 * Lookup --
 *	Searches a table of strings to find one that matches a given
 *	string.  It's useful mostly for command lookup.
 *
 *	Only the portion of a string in the table up to the first
 *	blank character is considered significant for matching.
 *
 * Results:
 *	If str is the same as
 *      or an unambiguous abbreviation for one of the entries
 *	in table, then the index of the matching entry is returned.
 *	If str is not the same as any entry in the table, but 
 *      an abbreviation for more than one entry, 
 *	then -1 is returned.  If str doesn't match any entry, then
 *	-2 is returned.  Case differences are ignored.
 *
 * NOTE:  
 *      Table entries need no longer be in alphabetical order
 *      and they need not be lower case.  The irouter command parsing
 *      depends on these features.
 *
 * Side Effects:
 *	None.
 *---------------------------------------------------------
 */

int
Lookup(str, table)
    char *str;			/* Pointer to a string to be looked up */
    char *(table[]);		/* Pointer to an array of string pointers
				 * which are the valid commands.  
				 * The end of
				 * the table is indicated by a NULL string.
				 */
{
    int match = -2;	/* result, initialized to -2 = no match */
    int pos;
    int ststart = 0;

    /* search for match */
    for (pos=0; table[pos] != NULL; pos++)
    {
	char *tabc = table[pos];
	char *strc = &(str[ststart]);
	while (*strc!='\0' && *tabc!=' ' &&
	    ((*tabc==*strc) ||
	     (isupper(*tabc) && islower(*strc) && (tolower(*tabc)== *strc))||
	     (islower(*tabc) && isupper(*strc) && (toupper(*tabc)== *strc)) ))
	{
	    strc++;
	    tabc++;
	}


	if (*strc=='\0') 
	{
	    /* entry matches */
	    if(*tabc==' ' || *tabc=='\0')
	    {
		/* exact match - record it and terminate search */
		match = pos;
		break;
	    }    
	    else if (match == -2)
	    {
		/* inexact match and no previous match - record this one 
		 * and continue search */
		match = pos;
	    }	
	    else
	    {
		/* previous match, so string is ambiguous unless exact
		 * match exists.  Mark ambiguous for now, and continue
		 * search.
		 */
		match = -1;
	    }
	}
    }
    return(match);
}

/*
 * ----------------------------------------------------------------------------
 * LookupFull --
 *
 * Look up a string in a table of pointers to strings.  The last
 * entry in the string table must be a NULL pointer.
 * This is much simpler than Lookup() in that it does not
 * allow abbreviations.  It does, however, ignore case.
 *
 * Results:
 *	Index of the name supplied in the table, or -1 if the name
 *	is not found.
 *
 * Side effects:
 *	None.
 *
 * ----------------------------------------------------------------------------
 */

int
LookupFull(name, table)
    char *name;
    char **table;
{
    char **tp;

    for (tp = table; *tp; tp++)
    {
	if (strcmp(name, *tp) == 0)
	    return (tp - table);
	else
	{
	    char *sptr, *tptr;
	    for (sptr = name, tptr = *tp; ((*sptr != '\0') && (*tptr != '\0'));
			sptr++, tptr++)
		if (toupper(*sptr) != toupper(*tptr))
		    break;
	    if ((*sptr == '\0') && (*tptr == '\0'))
		return (tp - table);
	}
    }

    return (-1);
}


/*
 *------------------------------------------------------------
 *
 * LefNextToken --
 *
 *	Move to the next token in the stream input.
 *	If "ignore_eol" is FALSE, then the end-of-line character
 *	"\n" will be returned as a token when encountered.
 *	Otherwise, end-of-line will be ignored.
 *
 * Results:
 *	Pointer to next token to parse
 *
 * Side Effects:
 *	May read a new line from the specified file.
 *
 * Warnings:
 *	The return result of LefNextToken will be overwritten by
 *	subsequent calls to LefNextToken if more than one line of
 *	input is parsed.
 *
 *------------------------------------------------------------
 */

char *
LefNextToken(FILE *f, u_char ignore_eol)
{
    static char line[LEF_LINE_MAX + 2];	/* input buffer */
    static char *nexttoken = NULL;	/* pointer to next token */
    static char *curtoken;		/* pointer to current token */
    static char eol_token='\n';

    /* Read a new line if necessary */

    if (nexttoken == NULL)
    {
	for(;;)
	{
	    if (fgets(line, LEF_LINE_MAX + 1, f) == NULL) return NULL;
	    lefCurrentLine++;
	    curtoken = line;
	    while (isspace(*curtoken) && (*curtoken != '\n') && (*curtoken != '\0'))
		curtoken++;		/* skip leading whitespace */

	    if ((*curtoken != '#') && (*curtoken != '\n') && (*curtoken != '\0'))
	    {
		nexttoken = curtoken;
		break;
	    }
	}
	if (!ignore_eol)
	    return &eol_token;
    }
    else
	curtoken = nexttoken;

    /* Find the next token; set to NULL if none (end-of-line). */
    /* Treat quoted material as a single token */

    if (*nexttoken == '\"') {
	nexttoken++;
	while (((*nexttoken != '\"') || (*(nexttoken - 1) == '\\')) &&
		(*nexttoken != '\0')) {
	    if (*nexttoken == '\n') { 	
		if (fgets(nexttoken + 1, LEF_LINE_MAX -
				(size_t)(nexttoken - line), f) == NULL)
		    return NULL;
	    }
	    nexttoken++;	/* skip all in quotes (move past current token) */
	}
	if (*nexttoken == '\"')
	    nexttoken++;
    }
    else {
	while (!isspace(*nexttoken) && (*nexttoken != '\0') && (*nexttoken != '\n'))
	    nexttoken++;	/* skip non-whitespace (move past current token) */
    }

    /* Terminate the current token */
    if (*nexttoken != '\0') *nexttoken++ = '\0';

    while (isspace(*nexttoken) && (*nexttoken != '\0') && (*nexttoken != '\n'))
	nexttoken++;	/* skip any whitespace */

    if ((*nexttoken == '#') || (*nexttoken == '\n') || (*nexttoken == '\0'))
	nexttoken = NULL;

    return curtoken;
}

/*
 *------------------------------------------------------------
 *
 * LefError --
 *
 *	Print an error message (via fprintf) giving the line
 *	number of the input file on which the error occurred.
 *
 *	"type" should be either LEF_ERROR or LEF_WARNING (or DEF_*).
 *
 * Results:
 *	None.
 *
 * Side Effects:
 *	Prints to the output (stderr).
 *
 *------------------------------------------------------------
 */

void
LefError(int type, char *fmt, ...)
{  
    static int fatal = 0;
    static int nonfatal = 0;
    char lefordef = 'L';
    int errors;
    va_list args;

    if (Verbose == 0) return;

    if ((type == DEF_WARNING) || (type == DEF_ERROR)) lefordef = 'D';

    errors = fatal + nonfatal;
    if (fmt == NULL)  /* Special case:  report any errors and reset */
    {
	if (errors > 0)
	{
	    fprintf(stdout, "%cEF Read: encountered %d error%s and %d warning%s total.\n",
			lefordef,
			fatal, (fatal == 1) ? "" : "s",
			nonfatal, (nonfatal == 1) ? "" : "s");
	    fatal = 0;
	    nonfatal = 0;
	}
	return;
    }

    if (errors < LEF_MAX_ERRORS)
    {
	fprintf(stderr, "%cEF Read, Line %d: ", lefordef, lefCurrentLine);
	va_start(args, fmt);
	vfprintf(stderr, fmt, args);
	va_end(args);
	fflush(stderr);
    }
    else if (errors == LEF_MAX_ERRORS)
	fprintf(stderr, "%cEF Read:  Further errors/warnings will not be reported.\n",
		lefordef);

    if ((type == LEF_ERROR) || (type == DEF_ERROR))
	fatal++;
    else if ((type == LEF_WARNING) || (type == DEF_WARNING))
	nonfatal++;
}

/*
 *------------------------------------------------------------
 *
 * LefParseEndStatement --
 *
 *	Check if the string passed in "lineptr" contains the
 *	appropriate matching keyword.  Sections in LEF files
 *	should end with "END (keyword)" or "END".  To check
 *	against the latter case, "match" should be NULL.
 *
 * Results:
 *	TRUE if the line matches the expected end statement,
 *	FALSE if not. 
 *
 * Side effects:
 *	None.
 *
 *------------------------------------------------------------
 */

u_char
LefParseEndStatement(FILE *f, char *match)
{
    char *token;
    int keyword;
    char *match_name[2];

    match_name[0] = match;
    match_name[1] = NULL;

    token = LefNextToken(f, (match == NULL) ? FALSE : TRUE);
    if (token == NULL)
    {
	LefError(LEF_ERROR, "Bad file read while looking for END statement\n");
	return FALSE;
    }

    /* END or ENDEXT */
    if ((*token == '\n') && (match == NULL)) return TRUE;

    /* END <section_name> */
    else {
	keyword = LookupFull(token, match_name);
	if (keyword == 0)
	    return TRUE;
	else
	    return FALSE;
    }
}

/*
 *------------------------------------------------------------
 *
 * LefSkipSection --
 *
 *	Skip to the "END" record of a LEF input section
 *	String "section" must follow the "END" statement in
 *	the file to be considered a match;  however, if
 *	section = NULL, then "END" must have no strings
 *	following.
 *
 * Results:
 *	None.
 *
 * Side Effects:
 *	Reads input from the specified file.  Prints an
 *	error message if the expected END record cannot
 *	be found.
 *
 *------------------------------------------------------------
 */

void
LefSkipSection(FILE *f, char *section)
{
    char *token;
    int keyword;
    static char *end_section[] = {
	"END",
	"ENDEXT",
	NULL
    };

    while ((token = LefNextToken(f, TRUE)) != NULL)
    {
	if ((keyword = Lookup(token, end_section)) == 0)
	{
	    if (LefParseEndStatement(f, section))
		return;
	}
	else if (keyword == 1)
	{
	    if (!strcmp(section, "BEGINEXT"))
		return;
	}
    }

    LefError(LEF_ERROR, "Section %s has no END record!\n", section);
    return;
}

/*
 *------------------------------------------------------------
 *
 * lefFindCell --
 *
 * 	"name" is the name of the cell to search for.
 *	Returns the GATE entry for the cell from the GateInfo
 *	hash table.
 *
 *------------------------------------------------------------
 */

GATE
lefFindCell(char *name)
{
    GATE gateginfo;

    gateginfo = (GATE)HashLookup(name, &MacroTable);
    return gateginfo;
}

/*
 *------------------------------------------------------------
 *
 * LefLower --
 *
 *	Convert a token in a LEF or DEF file to all-lowercase.
 *
 *------------------------------------------------------------
 */

char *
LefLower(char *token)
{
    char *tptr;

    for (tptr = token; *tptr != '\0'; tptr++)
	*tptr = tolower(*tptr);

    return token;
}

LefList
LefRedefined(LefList lefl, char *redefname)
{
    LefList slef, newlefl;
    char *altName;
    int records;
    DSEG drect;

    /* check if more than one entry points to the same	*/
    /* lefLayer record.	 If so, we will also record the	*/
    /* name of the first type that is not the same as	*/
    /* "redefname".					*/

    records = 0;
    altName = NULL;

    for (slef = LefInfo; slef; slef = slef->next) {
	if (slef == lefl)
	    records++;
	if (altName == NULL)
	    if (strcmp(slef->lefName, redefname))
		altName = (char *)slef->lefName;
    }
    if (records == 1)
    {
	/* Only one name associated with the record, so	*/
	/* just clear all the allocated information.	*/

        while (lefl->info.via.lr) {
	   drect = lefl->info.via.lr->next;
	   free(lefl->info.via.lr);
	   lefl->info.via.lr = drect;
	}
	newlefl = lefl;
    }
    else
    {
	slef = LefFindLayer(redefname);

	newlefl = (LefList)malloc(sizeof(lefLayer));
	newlefl->lefName = strdup(newlefl->lefName);

	newlefl->next = LefInfo;
	LefInfo = newlefl;

	/* If the canonical name of the original entry	*/
	/* is "redefname", then change it.		*/

	if (!strcmp(slef->lefName, redefname))
	    if (altName != NULL)
		slef->lefName = altName;
    }
    newlefl->type = -1;
    newlefl->obsType = -1;
    newlefl->info.via.area.x1 = 0.0;
    newlefl->info.via.area.x2 = 0.0;
    newlefl->info.via.area.y1 = 0.0;
    newlefl->info.via.area.y2 = 0.0;
    newlefl->info.via.area.layer = -1;
    newlefl->info.via.cell = (GATE)NULL;
    newlefl->info.via.lr = (DSEG)NULL;

    return newlefl;
}

/*
 *------------------------------------------------------------
 * Find a layer record in the list of layers
 *------------------------------------------------------------
 */

LefList
LefFindLayer(char *token)
{
    LefList lefl, rlefl;
   
    if (token == NULL) return NULL;
    rlefl = (LefList)NULL;
    for (lefl = LefInfo; lefl; lefl = lefl->next) {
	if (!strcmp(lefl->lefName, token)) {
	   rlefl = lefl;
	   break;
	}
    }
    return rlefl;
}
	
/*
 *------------------------------------------------------------
 * Find a layer record in the list of layers, by layer number
 *------------------------------------------------------------
 */

LefList
LefFindLayerByNum(int layer)
{
    LefList lefl, rlefl;
   
    rlefl = (LefList)NULL;
    for (lefl = LefInfo; lefl; lefl = lefl->next) {
	if (lefl->type == layer) {
	   rlefl = lefl;
	   break;
	}
    }
    return rlefl;
}
	
/*
 *------------------------------------------------------------
 * Find a layer record in the list of layers, and return the
 * layer number.
 *------------------------------------------------------------
 */

int
LefFindLayerNum(char *token)
{
    LefList lefl;

    lefl = LefFindLayer(token);
    if (lefl)
	return lefl->type;
    else
	return -1;
}

/*
 *---------------------------------------------------------------
 * Find the maximum layer number defined by the LEF file
 * This includes layer numbers assigned to both routes and
 * via cut layers.
 *---------------------------------------------------------------
 */

int
LefGetMaxLayer(void)
{
    int maxlayer = -1;
    LefList lefl;

    for (lefl = LefInfo; lefl; lefl = lefl->next) {
	if (lefl->type > maxlayer)
	    maxlayer = lefl->type;
    }
    return (maxlayer + 1);
}

/*
 *---------------------------------------------------------------
 * Find the maximum routing layer number defined by the LEF file
 * Note that as defined, this returns value (layer_index + 1).
 *---------------------------------------------------------------
 */

int
LefGetMaxRouteLayer(void)
{
    int maxlayer = -1;
    LefList lefl;

    for (lefl = LefInfo; lefl; lefl = lefl->next) {
	if (lefl->lefClass != CLASS_ROUTE) continue;
	if (lefl->type > maxlayer)
	    maxlayer = lefl->type;
    }
    return (maxlayer + 1);
}

/*
 *------------------------------------------------------------
 * Return the route keepout area, defined as the route space
 * plus 1/2 the route width.  This is the distance outward
 * from an obstruction edge within which one cannot place a
 * route.
 *
 * If no route layer is defined, then we pick up the value
 * from information in the route.cfg file (if any).  Here
 * we define it as the route pitch less 1/2 the route width,
 * which is the same as above if the route pitch has been
 * chosen for minimum spacing.
 *
 * If all else fails, return zero.
 *------------------------------------------------------------
 */

double
LefGetRouteKeepout(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.width / 2.0
		+ lefl->info.route.spacing->spacing;
	}
    }
    return 0.0;
}

/*
 *------------------------------------------------------------
 * Similar routine to the above.  Return the route width for
 * a route layer.  Return value in microns.  If there is no
 * LEF file information about the route width, then return
 * half of the minimum route pitch.
 *------------------------------------------------------------
 */

double
LefGetRouteWidth(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.width;
	}
    }
    return 0.0;
}

/*
 *------------------------------------------------------------
 * Similar to the above, return the width of a via.  Arguments
 * are the via record, the layer to check the width of, and
 * direction "dir" = 1 for height and 0 for width.
 *------------------------------------------------------------
 */

double
LefGetViaWidth(LefList lefl, int layer, int dir)
{
    double width, maxwidth;
    DSEG lrect;

    maxwidth = 0.0;

    if (lefl->lefClass == CLASS_VIA) {
        if (lefl->info.via.area.layer == layer) {
            if (dir)
                width = lefl->info.via.area.y2 - lefl->info.via.area.y1;
            else
                width = lefl->info.via.area.x2 - lefl->info.via.area.x1;
	    if (width > maxwidth) maxwidth = width;
        }
        for (lrect = lefl->info.via.lr; lrect; lrect = lrect->next) {
            if (lrect->layer == layer) {
                if (dir)
		    width = lrect->y2 - lrect->y1;
		else
		    width = lrect->x2 - lrect->x1;
	        if (width > maxwidth) maxwidth = width;
            }
        }
    }
    return maxwidth / 2;
}

/*
 *------------------------------------------------------------
 * Similar routine to the above.  Return the route offset for
 * a route layer.  Return value in microns.  If there is no
 * LEF file information about the route offset, then return
 * half of the minimum route pitch.
 *------------------------------------------------------------
 */

double
LefGetRouteOffset(int layer)
{
    LefList lefl;
    u_char o;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    o = lefl->info.route.hdirection;
            if (o == TRUE)
	        return lefl->info.route.offsety;
	    else
	        return lefl->info.route.offsetx;
	}
    }
    return 0.0;
}

double
LefGetRouteOffsetX(int layer)
{
    LefList lefl;
    u_char o;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.offsetx;
	}
    }
    return 0.0;
}

double
LefGetRouteOffsetY(int layer)
{
    LefList lefl;
    u_char o;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.offsety;
	}
    }
    return 0.0;
}

/*
 *------------------------------------------------------------
 * Find and return the minimum metal area requirement for a
 * route layer.
 *------------------------------------------------------------
 */

double
LefGetRouteMinArea(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.minarea;
	}
    }
    return 0.0;		/* Assume no minimum area requirement	*/
}

/*
 *------------------------------------------------------------
 * Get route spacing rule (minimum width)
 *------------------------------------------------------------
 */

double
LefGetRouteSpacing(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    if (lefl->info.route.spacing)
		return lefl->info.route.spacing->spacing;
	    else
		return 0.0;
	}
    }
    return 0.0;
}

/*
 *------------------------------------------------------------
 * Find route spacing to a metal layer of specific width
 *------------------------------------------------------------
 */

double
LefGetRouteWideSpacing(int layer, double width)
{
    LefList lefl;
    lefSpacingRule *srule;
    double spacing;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    // Prepare a default in case of bad values
	    spacing = lefl->info.route.spacing->spacing;
	    for (srule = lefl->info.route.spacing; srule; srule = srule->next) {
		if (srule->width > width) break;
		spacing = srule->spacing;
	    }
	    return spacing;
	}
    }
    return 0.0;
}

/*
 *-----------------------------------------------------------------
 * Get the route pitch in the preferred direction for a given layer
 *-----------------------------------------------------------------
 */

double
LefGetRoutePitch(int layer)
{
    LefList lefl;
    u_char o;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    o = lefl->info.route.hdirection;
            if (o == TRUE)
		return lefl->info.route.pitchy;
	    else
		return lefl->info.route.pitchx;
	}
    }
    return 0.0;
}

/*
 *------------------------------------------------------------
 * Get the route pitch in X for a given layer
 *------------------------------------------------------------
 */

double
LefGetRoutePitchX(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.pitchx;
	}
    }
    return 0.0;
}

/*
 *------------------------------------------------------------
 * Get the route pitch in Y for a given layer
 *------------------------------------------------------------
 */

double
LefGetRoutePitchY(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.pitchy;
	}
    }
    return 0.0;
}

/*
 *------------------------------------------------------------
 * Set the route pitch in X for a given layer
 *------------------------------------------------------------
 */

void
LefSetRoutePitchX(int layer, double value)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    lefl->info.route.pitchx = value;
	}
    }
}

/*
 *------------------------------------------------------------
 * Set the route pitch in Y for a given layer
 *------------------------------------------------------------
 */

void
LefSetRoutePitchY(int layer, double value)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    lefl->info.route.pitchy = value;
	}
    }
}

/*
 *------------------------------------------------------------
 * Get the route name for a given layer
 *------------------------------------------------------------
 */

char *
LefGetRouteName(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->lefName;
	}
    }
    return NULL;
}

/*
 *------------------------------------------------------------
 * Get the route orientation for the given layer,
 * where the result is 1 for horizontal, 0 for vertical, and
 * -1 if the layer is not found.
 *------------------------------------------------------------
 */

int
LefGetRouteOrientation(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return (int)lefl->info.route.hdirection;
	}
    }
    return -1;
}

/*
 *------------------------------------------------------------
 * Get the route resistance and capacitance information.
 * Fill in the pointer values with the relevant information.
 * Return 0 on success, -1 if the layer is not found.
 *------------------------------------------------------------
 */

int
LefGetRouteRCvalues(int layer, double *areacap, double *edgecap,
	double *respersq)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    *areacap = (double)lefl->info.route.areacap;
	    *edgecap = (double)lefl->info.route.edgecap;
	    *respersq = (double)lefl->info.route.respersq;
	    return 0;
	}
    }
    return -1;
}

/*
 *------------------------------------------------------------
 * Get the antenna violation area ratio for the given layer.
 *------------------------------------------------------------
 */

double
LefGetRouteAreaRatio(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.antenna;
	}
    }
    return 0.0;
}

/*
 *------------------------------------------------------------
 * Get the antenna violation area calculation method for the
 * given layer.
 *------------------------------------------------------------
 */

u_char
LefGetRouteAntennaMethod(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.method;
	}
    }
    return CALC_NONE;
}

/*
 *------------------------------------------------------------
 * Get the route metal layer thickness (if any is defined)
 *------------------------------------------------------------
 */

double
LefGetRouteThickness(int layer)
{
    LefList lefl;

    lefl = LefFindLayerByNum(layer);
    if (lefl) {
	if (lefl->lefClass == CLASS_ROUTE) {
	    return lefl->info.route.thick;
	}
    }
    return 0.0;
}

/*
 *------------------------------------------------------------
 * LefReadLayers --
 *
 *	Read a LEF "LAYER" record from the file.
 *	If "obstruct" is TRUE, returns the layer mapping
 *	for obstruction geometry as defined in the
 *	technology file (if it exists), and up to two
 *	types are returned (the second in the 3rd argument
 *	pointer).
 *
 * Results:
 *	Returns layer number or -1 if no matching type is found.
 *
 * Side Effects:
 *	Reads input from file f;
 *
 *------------------------------------------------------------
 */

int
LefReadLayers(f, obstruct, lreturn)
    FILE *f;
    u_char obstruct;
    int *lreturn;
{
    char *token;
    int curlayer = -1;
    LefList lefl = NULL;

    token = LefNextToken(f, TRUE);
    if (*token == ';')
    {
	LefError(LEF_ERROR, "Bad Layer statement\n");
	return -1;
    }
    else
    {
	lefl = LefFindLayer(token);
	if (lefl)
	{
	    if (obstruct)
	    {
		/* Use the obstruction type, if it is defined */
		curlayer = lefl->obsType;
		if ((curlayer < 0) && (lefl->lefClass != CLASS_IGNORE))
		    curlayer = lefl->type;
		else if (lefl->lefClass == CLASS_VIA || lefl->lefClass == CLASS_CUT)
		    if (lreturn) *lreturn = lefl->info.via.obsType;
	    }
	    else
	    {
		if (lefl->lefClass != CLASS_IGNORE)
		    curlayer = lefl->type;
	    }
	}
	if ((curlayer < 0) && ((!lefl) || (lefl->lefClass != CLASS_IGNORE)))
	{
	    /* CLASS_VIA in lefl record is a cut, and the layer */
	    /* geometry is ignored for the purpose of routing.	*/

	    if (lefl && (lefl->lefClass == CLASS_CUT)) {
		int cuttype;

		/* By the time a cut layer is being requested,	*/
		/* presumably from a VIA definition, the route	*/
		/* layers should all be defined, so start	*/
		/* assigning layers to cuts.			*/

		/* If a cut layer is found with an unassigned number,	*/
		/* then assign it here.					*/
		cuttype = LefGetMaxLayer();
		if (cuttype < MAX_TYPES) {
		    lefl->type = cuttype;
		    curlayer = cuttype;
		}
		else
		    LefError(LEF_WARNING, "Too many cut types;  type \"%s\" ignored.\n",
				token);
	    }
	    else if ((!lefl) || (lefl->lefClass != CLASS_VIA))
		LefError(LEF_ERROR, "Don't know how to parse layer \"%s\"\n", token);
	}
    }
    return curlayer;
}

/*
 *------------------------------------------------------------
 * LefReadLayer --
 *
 *	Read a LEF "LAYER" record from the file.
 *	If "obstruct" is TRUE, returns the layer mapping
 *	for obstruction geometry as defined in the
 *	technology file (if it exists).
 *
 * Results:
 *	Returns a layer number or -1 if no match is found.
 *
 * Side Effects:
 *	Reads input from file f;
 *
 *------------------------------------------------------------
 */

int
LefReadLayer(FILE *f, u_char obstruct)
{
    return LefReadLayers(f, obstruct, (int *)NULL);
}

/*
 *------------------------------------------------------------
 * LefReadRect --
 *
 *	Read a LEF "RECT" record from the file, and
 *	return a Rect in micron coordinates.
 *
 * Results:
 *	Returns a pointer to a Rect containing the micron
 *	coordinates, or NULL if an error occurred.
 *
 * Side Effects:
 *	Reads input from file f;
 *
 * Note:
 *	LEF/DEF does NOT define a RECT record as having (...)
 *	pairs, only routes.  However, at least one DEF file
 *	contains this syntax, so it is checked.
 *
 *------------------------------------------------------------
 */

DSEG
LefReadRect(FILE *f, int curlayer, float oscale)
{
    char *token;
    float llx, lly, urx, ury;
    static struct dseg_ paintrect;
    u_char needMatch = FALSE;

    token = LefNextToken(f, TRUE);
    if (*token == '(')
    {
	token = LefNextToken(f, TRUE);
	needMatch = TRUE;
    }
    if (!token || sscanf(token, "%f", &llx) != 1) goto parse_error;
    token = LefNextToken(f, TRUE);
    if (!token || sscanf(token, "%f", &lly) != 1) goto parse_error;
    token = LefNextToken(f, TRUE);
    if (needMatch)
    {
	if (*token != ')') goto parse_error;
	else token = LefNextToken(f, TRUE);
	needMatch = FALSE;
    }
    if (*token == '(')
    {
	token = LefNextToken(f, TRUE);
	needMatch = TRUE;
    }
    if (!token || sscanf(token, "%f", &urx) != 1) goto parse_error;
    token = LefNextToken(f, TRUE);
    if (!token || sscanf(token, "%f", &ury) != 1) goto parse_error;
    if (needMatch)
    {
	token = LefNextToken(f, TRUE);
	if (*token != ')') goto parse_error;
    }
    if (curlayer < 0) {
	/* Issue warning but keep geometry with negative layer number */
	LefError(LEF_WARNING, "No layer defined for RECT.\n");
    }

    /* Scale coordinates (microns to centimicrons)	*/
		
    paintrect.x1 = llx / oscale;
    paintrect.y1 = lly / oscale;
    paintrect.x2 = urx / oscale;
    paintrect.y2 = ury / oscale;
    paintrect.layer = curlayer;
    return (&paintrect);

parse_error:
    LefError(LEF_ERROR, "Bad port geometry: RECT requires 4 values.\n");
    return (DSEG)NULL;
}

/*
 *------------------------------------------------------------
 * LefReadEnclosure --
 *
 *	Read a LEF "ENCLOSURE" record from the file, and
 *	return a Rect in micron coordinates, representing
 *	the bounding box of the stated enclosure dimensions
 *	in both directions, centered on the origin.
 *
 * Results:
 *	Returns a pointer to a Rect containing the micron
 *	coordinates, or NULL if an error occurred.
 *
 * Side Effects:
 *	Reads input from file f
 *
 *------------------------------------------------------------
 */

DSEG
LefReadEnclosure(FILE *f, int curlayer, float oscale)
{
    char *token;
    float x, y, scale;
    static struct dseg_ paintrect;

    token = LefNextToken(f, TRUE);
    if (!token) goto enc_parse_error;

    if (sscanf(token, "%f", &x) != 1) {
	if (!strcmp(token, "BELOW") || !strcmp(token, "ABOVE"))
	    /* NOTE:  This creates two records but fails to differentiate   */
	    /* between the layers, both of which will be -1 if this is a    */
	    /* cut layer.  Needs to be handled properly.		    */

	    token = LefNextToken(f, TRUE);
	else
	    goto enc_parse_error;
    }
    token = LefNextToken(f, TRUE);
    if (!token || sscanf(token, "%f", &y) != 1) goto enc_parse_error;

    if (curlayer < 0) {
	/* Issue warning but keep geometry with negative layer number */
	LefError(LEF_ERROR, "No layer defined for RECT.\n");
    }

    /* Scale coordinates (microns to centimicrons) (doubled)	*/
		
    scale = oscale / 2.0;

    paintrect.x1 = -x / scale;
    paintrect.y1 = -y / scale;
    paintrect.x2 = x / scale;
    paintrect.y2 = y / scale;
    paintrect.layer = curlayer;
    return (&paintrect);

enc_parse_error:
    LefError(LEF_ERROR, "Bad enclosure geometry: ENCLOSURE requires 2 values.\n");
    return (DSEG)NULL;
}

/*
 *------------------------------------------------------------
 * Support routines for polygon reading
 *------------------------------------------------------------
 */

#define HEDGE 0		/* Horizontal edge */
#define REDGE 1		/* Rising edge */
#define FEDGE -1	/* Falling edge */

/*
 *------------------------------------------------------------
 * lefLowX ---
 *
 *	Sort routine to find the lowest X coordinate between
 *	two DPOINT structures passed from qsort()
 *------------------------------------------------------------
 */

int
lefLowX(DPOINT *a, DPOINT *b)
{
    DPOINT p = *a;
    DPOINT q = *b;

    if (p->x < q->x)
	return (-1);
    if (p->x > q->x)
	return (1);
    return (0);
}

/*
 *------------------------------------------------------------
 * lefLowY ---
 *
 *	Sort routine to find the lowest Y coordinate between
 *	two DPOINT structures passed from qsort()
 *------------------------------------------------------------
 */

int
lefLowY(DPOINT *a, DPOINT *b)
{
    DPOINT p = *a;
    DPOINT q = *b;

    if (p->y < q->y)
	return (-1);
    if (p->y > q->y)
	return (1);
    return (0);
}

/*
 *------------------------------------------------------------
 * lefOrient ---
 *
 *	Assign a direction to each of the edges in a polygon.
 *
 * Note that edges have been sorted, but retain the original
 * linked list pointers, from which we can determine the
 * path orientation
 *
 *------------------------------------------------------------
 */

char
lefOrient(DPOINT *edges, int nedges, int *dir)
{
    int n;
    DPOINT p, q;

    for (n = 0; n < nedges; n++)
    {
	p = edges[n];
	q = edges[n]->next;

	if (p->y == q->y)
	{
	    dir[n] = HEDGE;
	    continue;
	}
	if (p->x == q->x)
	{
	    if (p->y < q->y)
	    {
		dir[n] = REDGE;
		continue;
	    }
	    if (p->y > q->y)
	    {
		dir[n] = FEDGE;
		continue;
	    }
	    /* Point connects to itself */
	    dir[n] = HEDGE;
	    continue;
	}
	/* It's not Manhattan, folks. */
	return (FALSE);
    }
    return (TRUE);
}

/*
 *------------------------------------------------------------
 * lefCross ---
 *
 *	See if an edge crosses a particular area.
 *	Return TRUE if edge if vertical and if it crosses the
 *	y-range defined by ybot and ytop.  Otherwise return
 *	FALSE.
 *------------------------------------------------------------
 */

char
lefCross(DPOINT edge, int dir, double ybot, double ytop)
{
    double ebot, etop;

    switch (dir)
    {
	case REDGE:
	    ebot = edge->y;
	    etop = edge->next->y;
	    return (ebot <= ybot && etop >= ytop);

	case FEDGE:
	    ebot = edge->next->y;
	    etop = edge->y;
	    return (ebot <= ybot && etop >= ytop);
    }
    return (FALSE);
}

	
/*
 *------------------------------------------------------------
 * LefPolygonToRects --
 *
 *	Convert Geometry information from a POLYGON statement
 *	into rectangles.  NOTE:  For now, this routine
 *	assumes that all points are Manhattan.  It will flag
 *	non-Manhattan geometry
 *
 *	the DSEG pointed to by rectListPtr is updated by
 *	having the list of rectangles appended to it.
 *
 *------------------------------------------------------------
 */

void
LefPolygonToRects(DSEG *rectListPtr, DPOINT pointlist)
{
   DPOINT ptail, p, *pts, *edges;
   DSEG rtail, rex, new;
   int npts = 0;
   int *dir;
   int curr, wrapno, n;
   double xbot, xtop, ybot, ytop;

   if (pointlist == NULL) return;

   /* Close the path by duplicating 1st point if necessary */

   for (ptail = pointlist; ptail->next; ptail = ptail->next);

   if ((ptail->x != pointlist->x) || (ptail->y != pointlist->y))
   {
	p = (DPOINT)malloc(sizeof(struct dpoint_));
	p->x = pointlist->x;
	p->y = pointlist->y;
	p->layer = pointlist->layer;
	p->next = NULL;
	ptail->next = p;
    }

    // To do:  Break out non-manhattan parts here.
    // See CIFMakeManhattanPath in magic-8.0

    rex = NULL;
    for (p = pointlist; p->next; p = p->next, npts++);
    pts = (DPOINT *)malloc(npts * sizeof(DPOINT));
    edges = (DPOINT *)malloc(npts * sizeof(DPOINT));
    dir = (int *)malloc(npts * sizeof(int));
    npts = 0;

    for (p = pointlist; p->next; p = p->next, npts++)
    {
	// pts and edges are two lists of pointlist entries
	// that are NOT linked lists and can be shuffled
	// around by qsort().  The linked list "next" pointers
	// *must* be retained.

	pts[npts] = p;
	edges[npts] = p;
    }

    if (npts < 4)
    {
	LefError(LEF_ERROR, "Polygon with fewer than 4 points.\n");
	goto done;
    }

    /* Sort points by low y, edges by low x */
    qsort((char *)pts, npts, (int)sizeof(DPOINT), (__compar_fn_t)lefLowY);
    qsort((char *)edges, npts, (int)sizeof(DPOINT), (__compar_fn_t)lefLowX);

    /* Find out which direction each edge points */

    if (!lefOrient(edges, npts, dir))
    {
	LefError(LEF_ERROR, "I can't handle non-manhattan polygons!\n");
	goto done;
    }

    /* Scan the polygon from bottom to top.  At each step, process
     * a minimum-sized y-range of the polygon (i.e., a range such that
     * there are no vertices inside the range).  Use wrap numbers
     * based on the edge orientations to determine how much of the
     * x-range for this y-range should contain material.
     */

    for (curr = 1; curr < npts; curr++)
    {
	/* Find the next minimum-sized y-range. */

	ybot = pts[curr - 1]->y;
	while (ybot == pts[curr]->y)
	    if (++curr >= npts) goto done;
	ytop = pts[curr]->y;

	/* Process all the edges that cross the y-range, from left
	 * to right.
	 */

	for (wrapno = 0, n = 0; n < npts; n++)
	{
	    if (wrapno == 0) xbot = edges[n]->x;
	    if (!lefCross(edges[n], dir[n], ybot, ytop))
		continue;
	    wrapno += (dir[n] == REDGE) ? 1 : -1;
	    if (wrapno == 0)
	    {
		xtop = edges[n]->x;
		if (xbot == xtop) continue;
		new = (DSEG)malloc(sizeof(struct dseg_));
		new->x1 = xbot;
		new->x2 = xtop;
		new->y1 = ybot;
		new->y2 = ytop;
		new->layer = edges[n]->layer;
		new->next = rex;
		rex = new;
	    }
	}
    }

done:
    free(edges);
    free(dir);
    free(pts);

    if (*rectListPtr == NULL)
	*rectListPtr = rex;
    else
    {
	for (rtail = *rectListPtr; rtail->next; rtail = rtail->next);
	rtail->next = rex;
    }
}

/*
 *------------------------------------------------------------
 * LefReadPolygon --
 *
 *	Read Geometry information from a POLYGON statement
 *
 *------------------------------------------------------------
 */

DPOINT
LefReadPolygon(FILE *f, int curlayer, float oscale)
{
    DPOINT plist = NULL, newPoint;
    char *token;
    double px, py;

    while (1)
    {
	token = LefNextToken(f, TRUE);
	if (token == NULL || *token == ';') break;
	if (sscanf(token, "%lg", &px) != 1)
	{
	    LefError(LEF_ERROR, "Bad X value in polygon.\n");
	    LefEndStatement(f);
	    break;
	}

	token = LefNextToken(f, TRUE);
	if (token == NULL || *token == ';')
	{
	    LefError(LEF_ERROR, "Missing Y value in polygon point!\n");
	    break;
	}
	if (sscanf(token, "%lg", &py) != 1)
	{
	    LefError(LEF_ERROR, "Bad Y value in polygon.\n");
	    LefEndStatement(f);
	    break;
	}

	newPoint = (DPOINT)malloc(sizeof(struct dpoint_));
	newPoint->x = px / (double)oscale;
	newPoint->y = py / (double)oscale;
	newPoint->layer = curlayer;
	newPoint->next = plist;
	plist = newPoint;
    }

    return plist;
}

/*
 *------------------------------------------------------------
 * LefReadGeometry --
 *
 *	Read Geometry information from a LEF file.
 *	Used for PORT records and OBS statements.
 *
 * Results:
 *	Returns a linked list of all areas and types
 *	painted.
 *
 * Side Effects:
 *	Reads input from file f;
 *	Paints into the GATE lefMacro.
 *
 *------------------------------------------------------------
 */

enum lef_geometry_keys {LEF_LAYER = 0, LEF_WIDTH, LEF_PATH,
	LEF_RECT, LEF_POLYGON, LEF_VIA, LEF_PORT_CLASS,
	LEF_GEOMETRY_END};

DSEG
LefReadGeometry(GATE lefMacro, FILE *f, float oscale)
{
    int curlayer = -1, otherlayer = -1;

    char *token;
    int keyword;
    DSEG rectList = (DSEG)NULL;
    DSEG paintrect, newRect;
    DPOINT pointlist;

    static char *geometry_keys[] = {
	"LAYER",
	"WIDTH",
	"PATH",
	"RECT",
	"POLYGON",
	"VIA",
	"CLASS",
	"END",
	NULL
    };

    while ((token = LefNextToken(f, TRUE)) != NULL)
    {
	keyword = Lookup(token, geometry_keys);
	if (keyword < 0)
	{
	    LefError(LEF_WARNING, "Unknown keyword \"%s\" in LEF file; ignoring.\n",
			token);
	    LefEndStatement(f);
	    continue;
	}
	switch (keyword)
	{
	    case LEF_LAYER:
		curlayer = LefReadLayers(f, FALSE, &otherlayer);
		LefEndStatement(f);
		break;
	    case LEF_WIDTH:
		LefEndStatement(f);
		break;
	    case LEF_PATH:
		LefEndStatement(f);
		break;
	    case LEF_RECT:
		paintrect = (curlayer < 0) ? NULL : LefReadRect(f, curlayer, oscale);
		if (paintrect)
		{
		    /* Remember the area and layer */
		    newRect = (DSEG)malloc(sizeof(struct dseg_));
		    *newRect = *paintrect;
		    newRect->next = rectList;
		    rectList = newRect;
		}
		LefEndStatement(f);
		break;
	    case LEF_POLYGON:
		pointlist = LefReadPolygon(f, curlayer, oscale);
		LefPolygonToRects(&rectList, pointlist);
		break;
	    case LEF_VIA:
		LefEndStatement(f);
		break;
	    case LEF_PORT_CLASS:
		LefEndStatement(f);
		break;
	    case LEF_GEOMETRY_END:
		if (!LefParseEndStatement(f, NULL))
		{
		    LefError(LEF_ERROR, "Geometry (PORT or OBS) END statement missing.\n");
		    keyword = -1;
		}
		break;
	}
	if (keyword == LEF_GEOMETRY_END) break;
    }
    return rectList;
}

/*
 *------------------------------------------------------------
 * LefReadPort --
 *
 *	A wrapper for LefReadGeometry, which adds a label
 *	to the last rectangle generated by the geometry
 *	parsing.
 *
 * Results:
 *	None.
 *
 * Side Effects:
 *	Reads input from file f;
 *	Paints into the GATE lefMacro.
 *
 *------------------------------------------------------------
 */

void
LefReadPort(lefMacro, f, pinName, pinNum, pinDir, pinUse, pinArea, oscale)
    GATE lefMacro;
    FILE *f;
    char *pinName;
    int pinNum, pinDir, pinUse;
    double pinArea;
    float oscale;
{
    DSEG rectList, rlist;
    BUS bus;

    rectList = LefReadGeometry(lefMacro, f, oscale);

    if (pinNum >= 0) {
        int nodealloc, orignodes, ival;
	char *aptr;

	if (lefMacro->nodes <= pinNum) {
            orignodes = lefMacro->nodes;
	    lefMacro->nodes = (pinNum + 1);
            nodealloc = lefMacro->nodes / 10;
            if (nodealloc > (orignodes / 10)) {
		nodealloc++;
		lefMacro->taps = (DSEG *)realloc(lefMacro->taps,
			nodealloc * 10 * sizeof(DSEG));
		lefMacro->noderec = (NODE *)realloc(lefMacro->noderec,
			nodealloc * 10 * sizeof(NODE));
		lefMacro->direction = (u_char *)realloc(lefMacro->direction,
			nodealloc * 10 * sizeof(u_char));
		lefMacro->area = (float *)realloc(lefMacro->area,
			nodealloc * 10 * sizeof(float));
		lefMacro->use = (u_char *)realloc(lefMacro->use,
			nodealloc * 10 * sizeof(u_char));
		lefMacro->netnum = (int *)realloc(lefMacro->netnum,
			nodealloc * 10 * sizeof(int));
		lefMacro->node = (char **)realloc(lefMacro->node,
			nodealloc * 10 * sizeof(char *));
            } 
        }
	lefMacro->taps[pinNum] = rectList;
	lefMacro->noderec[pinNum] = NULL;
	lefMacro->area[pinNum] = 0.0;
	lefMacro->direction[pinNum] = (u_char)pinDir;
	lefMacro->area[pinNum] = pinArea;
	lefMacro->use[pinNum] = (u_char)pinUse;
	lefMacro->netnum[pinNum] = -1;
        if (pinName != NULL) {
            lefMacro->node[pinNum] = strdup(pinName);

	    /* Check for bus delimiters */
	    aptr = strrchr(pinName, delimiter);
	    if (aptr != NULL) {
		if (sscanf(aptr + 1, "%d", &ival) == 1) {
		     *aptr = '\0';

		     /* Add to bus list if needed, or adjust bounds */
		     for (bus = lefMacro->bus; bus; bus = bus->next) {
			 if (!strcmp(pinName, bus->busname)) {
			     if (ival > bus->high) bus->high = ival;
			     if (ival < bus->low) bus->low = ival;
			     break;
			 }
		     }
		     if (bus == NULL) {
			bus = (BUS)malloc(sizeof(struct bus_));
			bus->busname = strdup(pinName);
			bus->high = bus->low = ival;
			bus->next = lefMacro->bus;
			lefMacro->bus = bus;
		     }
		     *aptr = '[';
		}
	    }
	}
        else
	    lefMacro->node[pinNum] = NULL;
    }
    else {
       while (rectList) {
	  rlist = rectList->next;
	  free(rectList);
	  rectList = rlist;
       }
    }
}

/*
 *------------------------------------------------------------
 * LefReadPin --
 *
 *	Read a PIN statement from a LEF file.
 *
 * Results:
 *	0 if the pin had a port (success), 1 if not (indicating
 *	an unused pin that should be ignored).
 *
 * Side Effects:
 *	Reads input from file f;
 *	Paints into the GATE lefMacro.
 *
 *------------------------------------------------------------
 */

enum lef_pin_keys {LEF_DIRECTION = 0, LEF_USE, LEF_PORT, LEF_CAPACITANCE,
	LEF_ANTENNADIFF, LEF_ANTENNAGATE, LEF_ANTENNAMOD,
	LEF_ANTENNAPAR, LEF_ANTENNAPARSIDE, LEF_ANTENNAMAX, LEF_ANTENNAMAXSIDE,
	LEF_SHAPE, LEF_NETEXPR, LEF_PIN_END};

int
LefReadPin(lefMacro, f, pinname, pinNum, oscale)
   GATE lefMacro;
   FILE *f;
   char *pinname;
   int pinNum;
   float oscale;
{
    char *token;
    int keyword, subkey;
    int pinDir = PORT_CLASS_DEFAULT;
    int pinUse = PORT_USE_DEFAULT;
    float pinArea = 0.0;
    int retval = 1;

    static char *pin_keys[] = {
	"DIRECTION",
	"USE",
	"PORT",
	"CAPACITANCE",
	"ANTENNADIFFAREA",
	"ANTENNAGATEAREA",
	"ANTENNAMODEL",
	"ANTENNAPARTIALMETALAREA",
	"ANTENNAPARTIALMETALSIDEAREA",
	"ANTENNAMAXAREACAR",
	"ANTENNAMAXSIDEAREACAR",
	"SHAPE",
	"NETEXPR",
	"END",
	NULL
    };

    static char *pin_classes[] = {
	"DEFAULT",
	"INPUT",
	"OUTPUT",
	"OUTPUT TRISTATE",
	"INOUT",
	"FEEDTHRU",
	NULL
    };

    static int lef_class_to_bitmask[] = {
	PORT_CLASS_DEFAULT,
	PORT_CLASS_INPUT,
	PORT_CLASS_OUTPUT,
	PORT_CLASS_TRISTATE,
	PORT_CLASS_BIDIRECTIONAL,
	PORT_CLASS_FEEDTHROUGH
    };

    static char *pin_uses[] = {
	"DEFAULT",
	"SIGNAL",
	"ANALOG",
	"POWER",
	"GROUND",
	"CLOCK",
	"TIEOFF",
	"ANALOG",
	"SCAN",
	"RESET",
	NULL
    };

    static int lef_use_to_bitmask[] = {
	PORT_USE_DEFAULT,
	PORT_USE_SIGNAL,
	PORT_USE_ANALOG,
	PORT_USE_POWER,
	PORT_USE_GROUND,
	PORT_USE_CLOCK
    };

    while ((token = LefNextToken(f, TRUE)) != NULL)
    {
	keyword = Lookup(token, pin_keys);
	if (keyword < 0)
	{
	    LefError(LEF_WARNING, "Unknown keyword \"%s\" in LEF file; ignoring.\n",
			token);
	    LefEndStatement(f);
	    continue;
	}
	switch (keyword)
	{
	    case LEF_DIRECTION:
		token = LefNextToken(f, TRUE);
		subkey = Lookup(token, pin_classes);
		if (subkey < 0)
		    LefError(LEF_ERROR, "Improper DIRECTION statement\n");
		else
		    pinDir = lef_class_to_bitmask[subkey];
		LefEndStatement(f);
		break;
	    case LEF_USE:
		token = LefNextToken(f, TRUE);
		subkey = Lookup(token, pin_uses);
		if (subkey < 0)
		    LefError(LEF_ERROR, "Improper USE statement\n");
		else
		    pinUse = lef_use_to_bitmask[subkey];
		LefEndStatement(f);
		break;
	    case LEF_PORT:
		LefReadPort(lefMacro, f, pinname, pinNum, pinDir, pinUse, pinArea, oscale);
		retval = 0;
		break;
	    case LEF_ANTENNAGATE:
		/* Read off the next value as the pin's antenna gate area. */
		/* The layers or layers are not recorded. */
		token = LefNextToken(f, TRUE);
		sscanf(token, "%g", &pinArea);
		LefEndStatement(f);
		break;
	    case LEF_CAPACITANCE:
	    case LEF_ANTENNADIFF:
	    case LEF_ANTENNAMOD:
	    case LEF_ANTENNAPAR:
	    case LEF_ANTENNAPARSIDE:
	    case LEF_ANTENNAMAX:
	    case LEF_ANTENNAMAXSIDE:
	    case LEF_NETEXPR:
	    case LEF_SHAPE:
		LefEndStatement(f);	/* Ignore. . . */
		break;
	    case LEF_PIN_END:
		if (!LefParseEndStatement(f, pinname))
		{
		    LefError(LEF_ERROR, "Pin END statement missing.\n");
		    keyword = -1;
		}
		break;
	}
	if (keyword == LEF_PIN_END) break;
    }
    return retval;
}

/*
 *------------------------------------------------------------
 * LefEndStatement --
 *
 *	Read file input to EOF or a ';' token (end-of-statement)
 *	If we encounter a quote, make sure we don't terminate
 *	the statement on a semicolon that is part of the
 *	quoted material.
 *
 *------------------------------------------------------------
 */

void
LefEndStatement(FILE *f)
{
    char *token;

    while ((token = LefNextToken(f, TRUE)) != NULL)
	if (*token == ';') break;
}

/*
 *------------------------------------------------------------
 *
 * LefReadMacro --
 *
 *	Read in a MACRO section from a LEF file.
 *
 * Results:
 *	None.
 *
 * Side Effects:
 *	Creates a new cell definition in the database.
 *
 *------------------------------------------------------------
 */

enum lef_macro_keys {LEF_CLASS = 0, LEF_SIZE, LEF_ORIGIN,
	LEF_SYMMETRY, LEF_SOURCE, LEF_SITE, LEF_PIN, LEF_OBS,
	LEF_TIMING, LEF_FOREIGN, LEF_MACRO_END};

void
LefReadMacro(f, mname, oscale)
    FILE *f;			/* LEF file being read	*/
    char *mname;		/* name of the macro 	*/
    float oscale;		/* scale factor to um, usually 1 */
{
    GATE lefMacro, altMacro;
    char *token, *pname, tsave[128];
    int keyword, pinNum, subkey;
    float x, y;
    u_char has_size, is_imported = FALSE;
    struct dseg_ lefBBox;

    static char *macro_keys[] = {
	"CLASS",
	"SIZE",
	"ORIGIN",
	"SYMMETRY",
	"SOURCE",
	"SITE",
	"PIN",
	"OBS",
	"TIMING",
	"FOREIGN",
	"END",
	NULL
    };

    static char *macro_classes[] = {
	"DEFAULT",
	"CORE",
	"BLOCK",
	"PAD",
	"RING",
	"COVER",
	"ENDCAP",
	NULL
    };

    static int lef_macro_class_to_bitmask[] = {
	MACRO_CLASS_DEFAULT,
	MACRO_CLASS_CORE,
	MACRO_CLASS_BLOCK,
	MACRO_CLASS_PAD,
	MACRO_CLASS_RING,
	MACRO_CLASS_COVER,
	MACRO_CLASS_ENDCAP
    };

    static char *macro_subclasses[] = {
	";",
	"SPACER",
	"ANTENNACELL",
	"WELLTAP",
	"TIEHIGH",
	"TIELOW",
	"FEEDTHRU"
    };

    static int lef_macro_subclass_to_bitmask[] = {
	MACRO_SUBCLASS_NONE,
	MACRO_SUBCLASS_SPACER,
	MACRO_SUBCLASS_ANTENNA,
	MACRO_SUBCLASS_WELLTAP,
	MACRO_SUBCLASS_TIEHIGH,
	MACRO_SUBCLASS_TIELOW,
	MACRO_SUBCLASS_FEEDTHRU
    };

    /* Start by creating a new celldef */

    lefMacro = (GATE)NULL;
    for (altMacro = GateInfo; altMacro; altMacro = altMacro->next)
    {
	if (!strcmp(altMacro->gatename, mname)) {
	    lefMacro = altMacro;
	    break;
	}
    }

    while (lefMacro)
    {
	int suffix;
	char newname[256];

	altMacro = lefMacro;
	for (suffix = 1; altMacro != NULL; suffix++)
	{
	    sprintf(newname, "%250s_%d", mname, suffix);
	    for (altMacro = GateInfo; altMacro; altMacro = altMacro->next)
		if (!strcmp(altMacro->gatename, newname))
		    break;
	}
	LefError(LEF_WARNING, "Cell \"%s\" was already defined in this file.  "
		"Renaming original cell \"%s\"\n", mname, newname);

	lefMacro->gatename = strdup(newname);
	lefMacro = lefFindCell(mname);
    }

    // Create the new cell
    lefMacro = (GATE)malloc(sizeof(struct gate_));
    lefMacro->gatename = strdup(mname);
    lefMacro->gatetype = NULL;
    lefMacro->gateclass = MACRO_CLASS_DEFAULT;
    lefMacro->gatesubclass = MACRO_SUBCLASS_NONE;
    lefMacro->width = 0.0;
    lefMacro->height = 0.0;
    lefMacro->placedX = 0.0;
    lefMacro->placedY = 0.0;
    lefMacro->obs = (DSEG)NULL;
    lefMacro->next = GateInfo;
    lefMacro->last = (GATE)NULL;
    lefMacro->nodes = 0;
    lefMacro->orient = 0;
    // Allocate memory for up to 10 pins initially
    lefMacro->taps = (DSEG *)malloc(10 * sizeof(DSEG));
    lefMacro->noderec = (NODE *)malloc(10 * sizeof(NODE));
    lefMacro->direction = (u_char *)malloc(10 * sizeof(u_char));
    lefMacro->area = (float *)malloc(10 * sizeof(float));
    lefMacro->use = (u_char *)malloc(10 * sizeof(u_char));
    lefMacro->netnum = (int *)malloc(10 * sizeof(int));
    lefMacro->node = (char **)malloc(10 * sizeof(char *));
    // Fill in 1st entry
    lefMacro->taps[0] = NULL;
    lefMacro->noderec[0] = NULL;
    lefMacro->area[0] = 0.0;
    lefMacro->node[0] = NULL;
    lefMacro->bus = NULL;
    lefMacro->netnum[0] = -1;
    lefMacro->clientdata = (void *)NULL;
    GateInfo = lefMacro;

    /* Set gate type to the site name for site definitions */
    pname = mname;
    if (!strncmp(mname, "site_", 5)) pname += 5;

    /* Initial values */
    pinNum = 0;
    has_size = FALSE;
    lefBBox.x2 = lefBBox.x1 = 0.0;
    lefBBox.y2 = lefBBox.y1 = 0.0;

    while ((token = LefNextToken(f, TRUE)) != NULL)
    {
	keyword = Lookup(token, macro_keys);
	if (keyword < 0)
	{
	    LefError(LEF_WARNING, "Unknown keyword \"%s\" in LEF file; ignoring.\n",
			token);
	    LefEndStatement(f);
	    continue;
	}
	switch (keyword)
	{
	    case LEF_CLASS:
		token = LefNextToken(f, TRUE);
		subkey = Lookup(token, macro_classes);
		if (subkey < 0) {
		    LefError(LEF_ERROR, "Improper macro CLASS statement\n");
		    lefMacro->gateclass = MACRO_CLASS_DEFAULT;
		}
		else
		    lefMacro->gateclass = lef_macro_class_to_bitmask[subkey];
		token = LefNextToken(f, TRUE);
		if (token) {
		    subkey = Lookup(token, macro_subclasses);
		    if (subkey < 0) {
			lefMacro->gatesubclass = MACRO_SUBCLASS_NONE;
			LefEndStatement(f);
		    }
		    else if (subkey > 0) {
			lefMacro->gatesubclass = lef_macro_subclass_to_bitmask[subkey];
			LefEndStatement(f);
		    }
		    else
			lefMacro->gatesubclass = MACRO_SUBCLASS_NONE;
		}
		else
		    LefEndStatement(f);
		break;
	    case LEF_SIZE:
		token = LefNextToken(f, TRUE);
		if (!token || sscanf(token, "%f", &x) != 1) goto size_error;
		token = LefNextToken(f, TRUE);		/* skip keyword "BY" */
		if (!token) goto size_error;
		token = LefNextToken(f, TRUE);
		if (!token || sscanf(token, "%f", &y) != 1) goto size_error;

		lefBBox.x2 = x + lefBBox.x1;
		lefBBox.y2 = y + lefBBox.y1;
		has_size = TRUE;
		LefEndStatement(f);
		break;
size_error:
		LefError(LEF_ERROR, "Bad macro SIZE; requires values X BY Y.\n");
		LefEndStatement(f);
		break;
	    case LEF_ORIGIN:
		token = LefNextToken(f, TRUE);
		if (!token || sscanf(token, "%f", &x) != 1) goto origin_error;
		token = LefNextToken(f, TRUE);
		if (!token || sscanf(token, "%f", &y) != 1) goto origin_error;

		lefBBox.x1 = -x;
		lefBBox.y1 = -y;
		if (has_size)
		{
		    lefBBox.x2 += lefBBox.x1;
		    lefBBox.y2 += lefBBox.y1;
		}
		LefEndStatement(f);
		break;
origin_error:
		LefError(LEF_ERROR, "Bad macro ORIGIN; requires 2 values.\n");
		LefEndStatement(f);
		break;
	    case LEF_SYMMETRY:
		token = LefNextToken(f, TRUE);
		if (*token != '\n')
		    // DBPropPut(lefMacro, "LEFsymmetry", token + strlen(token) + 1);
		    ;
		LefEndStatement(f);
		break;
	    case LEF_SOURCE:
		token = LefNextToken(f, TRUE);
		if (*token != '\n')
		    // DBPropPut(lefMacro, "LEFsource", token);
		    ;
		LefEndStatement(f);
		break;
	    case LEF_SITE:
		token = LefNextToken(f, TRUE);
		if (*token != '\n')
		    // DBPropPut(lefMacro, "LEFsite", token);
		    ;
		LefEndStatement(f);
		break;
	    case LEF_PIN:
		token = LefNextToken(f, TRUE);
		/* Diagnostic */
		/*
		fprintf(stdout, "   Macro defines pin %s\n", token);
		*/
		sprintf(tsave, "%.127s", token);
		if (is_imported)
		    LefSkipSection(f, tsave);
		else
		    if (LefReadPin(lefMacro, f, tsave, pinNum, oscale) == 0)
			pinNum++;
		break;
	    case LEF_OBS:
		/* Diagnostic */
		/*
		fprintf(stdout, "   Macro defines obstruction\n");
		*/
		if (is_imported)
		    LefSkipSection(f, NULL);
		else 
		    lefMacro->obs = LefReadGeometry(lefMacro, f, oscale);
		break;
	    case LEF_TIMING:
		LefSkipSection(f, macro_keys[LEF_TIMING]);
		break;
	    case LEF_FOREIGN:
		LefEndStatement(f);
		break;
	    case LEF_MACRO_END:
		pname = mname;
		if (!strncmp(mname, "site_", 5)) pname += 5;
		if (!LefParseEndStatement(f, pname))
		{
		    LefError(LEF_ERROR, "Macro END statement missing.\n");
		    keyword = -1;
		}
		break;
	}
	if (keyword == LEF_MACRO_END) break;
    }

    /* Finish up creating the cell */

    if (lefMacro) {
	if (has_size) {
	    lefMacro->width = (lefBBox.x2 - lefBBox.x1);
	    lefMacro->height = (lefBBox.y2 - lefBBox.y1);

	    /* "placed" for macros (not instances) corresponds to the	*/
	    /* cell origin.						*/

	    lefMacro->placedX = lefBBox.x1;
	    lefMacro->placedY = lefBBox.y1;
	}
	else {
	    LefError(LEF_ERROR, "Gate %s has no size information!\n", lefMacro->gatename);
	}
    }
}

/*
 *------------------------------------------------------------
 *
 * LefAddViaGeometry --
 *
 *	Read in geometry for a VIA section from a LEF or DEF
 *	file.
 *
 *	f		LEF file being read
 *	lefl		pointer to via info
 *	curlayer	current tile type
 *	oscale		output scaling
 *
 * Results:
 *	None.
 *
 * Side Effects:
 *	Adds to the lefLayer record for a via definition.
 *
 *------------------------------------------------------------
 */

void
LefAddViaGeometry(FILE *f, LefList lefl, int curlayer, float oscale)
{
    DSEG currect;
    DSEG viarect;

    /* Rectangles for vias are read in units of 1/2 lambda */
    currect = LefReadRect(f, curlayer, (oscale / 2));
    if (currect == NULL) return;

    /* First rect goes into info.via.area, others go into info.via.lr */
    if (lefl->info.via.area.layer < 0)
    {
	lefl->info.via.area = *currect;

	/* If entries exist for info.via.lr, this is a via GENERATE	*/
	/* statement, and metal enclosures have been parsed.  Therefore	*/
	/* add the via dimensions to the enclosure rectangles.		*/

	viarect = lefl->info.via.lr;
	while (viarect != NULL) {
	    viarect->x1 += currect->x1;
	    viarect->x2 += currect->x2;
	    viarect->y1 += currect->y1;
	    viarect->y2 += currect->y2;
	    viarect = viarect->next;
	}
    }
    else 
    {
	viarect = (DSEG)malloc(sizeof(struct dseg_));
	*viarect = *currect;
	viarect->next = lefl->info.via.lr;
	lefl->info.via.lr = viarect;
    }
}

/*
 *------------------------------------------------------------
 *
 * LefNewRoute ---
 *
 *     Allocate space for and fill out default records of a
 *     route layer.
 * 
 *------------------------------------------------------------
 */

LefList LefNewRoute(char *name)
{
    LefList lefl;

    lefl = (LefList)malloc(sizeof(lefLayer));
    lefl->type = -1;
    lefl->obsType = -1;
    lefl->lefClass = CLASS_IGNORE;	/* For starters */
    lefl->lefName = strdup(name);

    return lefl;
}

/*
 *------------------------------------------------------------
 *
 * LefNewVia ---
 *
 *     Allocate space for and fill out default records of a
 *     via definition.
 * 
 *------------------------------------------------------------
 */

LefList LefNewVia(char *name)
{
    LefList lefl;

    lefl = (LefList)calloc(1, sizeof(lefLayer));
    lefl->type = -1;
    lefl->obsType = -1;
    lefl->lefClass = CLASS_VIA;
    lefl->info.via.area.x1 = 0.0;
    lefl->info.via.area.y1 = 0.0;
    lefl->info.via.area.x2 = 0.0;
    lefl->info.via.area.y2 = 0.0;
    lefl->info.via.area.layer = -1;
    lefl->info.via.cell = (GATE)NULL;
    lefl->info.via.lr = (DSEG)NULL;
    lefl->info.via.generated = FALSE;
    lefl->info.via.respervia = 0.0;
    lefl->info.via.spacing = (lefSpacingRule *)NULL;
    if (name != NULL)
	lefl->lefName = strdup(name);
    else
	lefl->lefName = NULL;

    return lefl;
}

/* Note:  Used directly below, as it is passed to variable "mode"
 * in LefReadLayerSection().  However, mainly used in LefRead().
 */

enum lef_sections {LEF_VERSION = 0,
	LEF_BUSBITCHARS, LEF_DIVIDERCHAR, LEF_MANUFACTURINGGRID,
	LEF_USEMINSPACING, LEF_CLEARANCEMEASURE,
	LEF_NAMESCASESENSITIVE, LEF_PROPERTYDEFS, LEF_UNITS,
	LEF_SECTION_LAYER, LEF_SECTION_VIA, LEF_SECTION_VIARULE,
	LEF_SECTION_SPACING, LEF_SECTION_SITE, LEF_PROPERTY,
	LEF_NOISETABLE, LEF_CORRECTIONTABLE, LEF_IRDROP,
	LEF_ARRAY, LEF_SECTION_TIMING, LEF_EXTENSION, LEF_MACRO,
	LEF_END};
/*
 *------------------------------------------------------------
 *
 * LefReadLayerSection --
 *
 *	Read in a LAYER, VIA, or VIARULE section from a LEF file.
 *
 * Results:
 *	None.
 *
 * Side Effects:
 *
 *------------------------------------------------------------
 */

enum lef_layer_keys {LEF_LAYER_TYPE=0, LEF_LAYER_WIDTH,
	LEF_LAYER_MINWIDTH, LEF_LAYER_MAXWIDTH, LEF_LAYER_AREA,
	LEF_LAYER_SPACING, LEF_LAYER_SPACINGTABLE,
	LEF_LAYER_PITCH, LEF_LAYER_DIRECTION, LEF_LAYER_OFFSET,
	LEF_LAYER_WIREEXT,
	LEF_LAYER_RES, LEF_LAYER_CAP, LEF_LAYER_EDGECAP,
	LEF_LAYER_THICKNESS, LEF_LAYER_HEIGHT,
	LEF_LAYER_MINDENSITY, LEF_LAYER_ANTENNA,
	LEF_LAYER_ANTENNADIFF, LEF_LAYER_ANTENNASIDE,
	LEF_LAYER_AGG_ANTENNA, LEF_LAYER_AGG_ANTENNADIFF,
	LEF_LAYER_AGG_ANTENNASIDE,
	LEF_LAYER_ACCURRENT, LEF_LAYER_DCCURRENT,
	LEF_VIA_DEFAULT, LEF_VIA_LAYER, LEF_VIA_RECT,
	LEF_VIA_ENCLOSURE, LEF_VIA_PREFERENCLOSURE,
	LEF_VIARULE_OVERHANG,
	LEF_VIARULE_METALOVERHANG, LEF_VIARULE_VIA,
	LEF_VIARULE_GENERATE, LEF_LAYER_END};

enum lef_spacing_keys {LEF_SPACING_RANGE=0, LEF_SPACING_BY,
	LEF_SPACING_ADJACENTCUTS, LEF_END_LAYER_SPACING};

void
LefReadLayerSection(f, lname, mode, lefl)
    FILE *f;			/* LEF file being read	  */
    char *lname;		/* name of the layer 	  */
    int mode;			/* layer, via, or viarule */
    LefList lefl;		/* pointer to layer info  */
{
    char *token, *tp;
    int keyword, typekey = -1, entries, i;
    int curlayer = -1;
    double dvalue, oscale;
    LefList altVia;
    lefSpacingRule *newrule = NULL, *testrule;

    /* These are defined in the order of CLASS_* in lefInt.h */
    static char *layer_type_keys[] = {
	"ROUTING",
	"CUT",
	"MASTERSLICE",
	"OVERLAP",
	NULL
    };

    static char *layer_keys[] = {
	"TYPE",
	"WIDTH",
	"MINWIDTH",
	"MAXWIDTH",
	"AREA",
	"SPACING",
	"SPACINGTABLE",
	"PITCH",
	"DIRECTION",
	"OFFSET",
	"WIREEXTENSION",
	"RESISTANCE",
	"CAPACITANCE",
	"EDGECAPACITANCE",
	"THICKNESS",
	"HEIGHT",
	"MINIMUMDENSITY",
	"ANTENNAAREARATIO",
	"ANTENNADIFFAREARATIO",
	"ANTENNASIDEAREARATIO",
	"ANTENNACUMAREARATIO",
	"ANTENNACUMDIFFAREARATIO",
	"ANTENNACUMSIDEAREARATIO",
	"ACCURRENTDENSITY",
	"DCCURRENTDENSITY",
	"DEFAULT",
	"LAYER",
	"RECT",
	"ENCLOSURE",
	"PREFERENCLOSURE",
	"OVERHANG",
	"METALOVERHANG",
	"VIA",
	"GENERATE",
	"END",
	NULL
    };

    static char *spacing_keys[] = {
	"RANGE",
	"BY",
	"ADJACENTCUTS",
	";",
	NULL
    };

    /* Database is assumed to be in microns.			*/
    /* If not, we need to parse the UNITS record, which is	*/
    /* currently ignored.					*/

    oscale = 1;

    while ((token = LefNextToken(f, TRUE)) != NULL)
    {
	keyword = Lookup(token, layer_keys);
	if (keyword < 0)
	{
	    LefError(LEF_WARNING, "Unknown keyword \"%s\" in LEF file; ignoring.\n",
			token);
	    LefEndStatement(f);
	    continue;
	}
	switch (keyword)
	{
	    case LEF_LAYER_TYPE:
		token = LefNextToken(f, TRUE);
		if (*token != '\n')
		{
		    typekey = Lookup(token, layer_type_keys);
		    if (typekey < 0)
			LefError(LEF_WARNING, "Unknown layer type \"%s\" in LEF file; "
				"ignoring.\n", token);
		}
		if (lefl->lefClass == CLASS_IGNORE) {
		    lefl->lefClass = typekey;
		    if (typekey == CLASS_ROUTE) {

			lefl->info.route.width = 0.0;
			lefl->info.route.spacing = NULL;
			lefl->info.route.pitchx = 0.0;
			lefl->info.route.pitchy = 0.0;
			// Use -1.0 as an indication that offset has not
			// been specified and needs to be set to default.
			lefl->info.route.offsetx = -1.0;
			lefl->info.route.offsety = -1.0;
			lefl->info.route.hdirection = DIR_UNKNOWN;

			lefl->info.route.minarea = 0.0;
			lefl->info.route.thick = 0.0;
			lefl->info.route.antenna = 0.0;
			lefl->info.route.method = CALC_NONE;

			lefl->info.route.areacap = 0.0;
			lefl->info.route.respersq = 0.0;
			lefl->info.route.edgecap = 0.0;

			/* A routing type has been declared.  Assume	*/
			/* this takes the name "metal1", "M1", or some	*/
			/* variant thereof.				*/

		        for (tp = lefl->lefName; *tp != '\0'; tp++) {
			    if (*tp >= '0' && *tp <= '9') {
				sscanf(tp, "%d", &lefl->type);

				/* "metal1", e.g., is assumed to be layer #0 */
				/* This may not be a proper assumption, always */

				lefl->type--;
				break;
			    }
			}

			/* This is probably some special non-numerical 	*/
			/* name for a top metal layer.  Take a stab at	*/
			/* it, defining it to be the next layer up from	*/
			/* whatever the previous topmost route layer	*/
			/* was.  This should work unless the LEF file	*/
			/* is incorrectly written.			*/

			if (lefl->type < 0) {
			    lefl->type = LefGetMaxRouteLayer();
			}
		    }
		    else if (typekey == CLASS_CUT || typekey == CLASS_VIA) {
			lefl->info.via.spacing = NULL;
			lefl->info.via.area.x1 = 0.0;
			lefl->info.via.area.y1 = 0.0;
			lefl->info.via.area.x2 = 0.0;
			lefl->info.via.area.y2 = 0.0;
			lefl->info.via.area.layer = -1;
			lefl->info.via.cell = (GATE)NULL;
			lefl->info.via.lr = (DSEG)NULL;

			/* Note:  lefl->type not set here for cut	*/
			/* layers so that route layers will all be	*/
			/* clustered at the bottom.			*/
		    }
		}
		else if (lefl->lefClass != typekey) {
		    LefError(LEF_ERROR, "Attempt to reclassify layer %s from %s to %s\n",
				lname, layer_type_keys[lefl->lefClass],
				layer_type_keys[typekey]);
		}
		LefEndStatement(f);
		break;
	    case LEF_LAYER_ACCURRENT:
		// Not used, but syntax is f**king stupid and has to be
		// specially handled, or it breaks the parser.
		token = LefNextToken(f, TRUE);	/* "AVERAGE", ... */
		token = LefNextToken(f, TRUE);	/* Value or "FREQUENCY" */
		LefEndStatement(f);
		if (!strcmp(token, "FREQUENCY"))
		{
		    while (TRUE) {
			token = LefNextToken(f, TRUE);
			LefEndStatement(f);
			if (!strcmp(token, "TABLEENTRIES")) {
			    break;
			}
		    }
		}
		break;
	    case LEF_LAYER_DCCURRENT:
		// Not used.  See comments above for ACCURRENTDENSITY
		token = LefNextToken(f, TRUE);	    /* "AVERAGE" */
		token = LefNextToken(f, TRUE);	    /* Value or "WIDTH" */
		LefEndStatement(f);
		if (!strcmp(token, "WIDTH"))
		{
		    while (TRUE) {
			token = LefNextToken(f, TRUE);
			LefEndStatement(f);
			if (!strcmp(token, "TABLEENTRIES")) {
			    break;
			}
		    }
		}
		break;
	    case LEF_LAYER_MINWIDTH:
		// Not handled if width is already defined.
		if ((lefl->lefClass != CLASS_ROUTE) ||
		    	(lefl->info.route.width != 0)) {
		    LefEndStatement(f);
		    break;
		}
		/* drop through */
	    case LEF_LAYER_WIDTH:
		token = LefNextToken(f, TRUE);
		sscanf(token, "%lg", &dvalue);
		if (lefl->lefClass == CLASS_ROUTE)
		    lefl->info.route.width = dvalue / (double)oscale;
		else if (lefl->lefClass == CLASS_CUT) {
		    double baseval = (dvalue / (double)oscale) / 2.0;
		    lefl->info.via.area.x1 = -baseval;
		    lefl->info.via.area.y1 = -baseval;
		    lefl->info.via.area.x2 = baseval;
		    lefl->info.via.area.y2 = baseval;
		}
		LefEndStatement(f);
		break;
	    case LEF_LAYER_MAXWIDTH:
		// Not handled.
		LefEndStatement(f);
		break;
	    case LEF_LAYER_AREA:
		/* Read minimum area rule value */
		token = LefNextToken(f, TRUE);
		if (lefl->lefClass == CLASS_ROUTE) {
		    sscanf(token, "%lg", &dvalue);
		    // Units of area (length * length)
		    lefl->info.route.minarea = dvalue / (double)oscale / (double)oscale;
		}
		LefEndStatement(f);
		break;
	    case LEF_LAYER_SPACING:
		if ((lefl->lefClass != CLASS_ROUTE) && (lefl->lefClass != CLASS_CUT) &&
			(lefl->lefClass != CLASS_VIA)) {
		    LefEndStatement(f);
		    break;
		}
		token = LefNextToken(f, TRUE);
		sscanf(token, "%lg", &dvalue);
		token = LefNextToken(f, TRUE);
		typekey = Lookup(token, spacing_keys);

		newrule = (lefSpacingRule *)malloc(sizeof(lefSpacingRule));

		// If no range specified, then the rule goes in front
		if (typekey == LEF_SPACING_RANGE) {
		    // Get range minimum, ignore range maximum, and sort
		    // the spacing order.
		    newrule->spacing = dvalue / (double)oscale;
		    token = LefNextToken(f, TRUE);
		    sscanf(token, "%lg", &dvalue);
		    newrule->width = dvalue / (double)oscale;
		    for (testrule = lefl->info.route.spacing; testrule;
				testrule = testrule->next)
			if (testrule->next == NULL || testrule->next->width >
				newrule->width)
			    break;

		    if (!testrule) {
			newrule->next = NULL;
			lefl->info.route.spacing = newrule;
		    }
		    else {
			newrule->next = testrule->next;
			testrule->next = newrule;
		    }
		    token = LefNextToken(f, TRUE);
		    typekey = Lookup(token, spacing_keys);
		}
		else if (typekey == LEF_SPACING_BY) {
		    /* In info.via.spacing, save two rules;  first one	*/
		    /* is for X spacing, second is for Y spacing	*/

		    newrule->spacing = dvalue / (double)oscale;
		    newrule->width = 0;
		    newrule->next = NULL;
		    lefl->info.via.spacing = newrule;

		    token = LefNextToken(f, TRUE);
		    sscanf(token, "%lg", &dvalue);
		    newrule = (lefSpacingRule *)malloc(sizeof(lefSpacingRule));
		    newrule->spacing = dvalue / (double)oscale;
		    newrule->width = 0;
		    newrule->next = NULL;
		    lefl->info.via.spacing->next = newrule;
		}
		else if (typekey == LEF_SPACING_ADJACENTCUTS) {
		    /* ADJACENTCUTS not handled here (yet) */
		    /* Need this for power post generation in addspacers */
		    /* (Do nothing here) */
		}
		else if (typekey >= 0) {
		    newrule->spacing = dvalue / (double)oscale;
		    newrule->width = 0.0;
		    newrule->next = lefl->info.route.spacing;
		    lefl->info.route.spacing = newrule;
		}
		if (typekey != LEF_END_LAYER_SPACING)
		    LefEndStatement(f);
		break;

	    case LEF_LAYER_SPACINGTABLE:
		// Use the values for the maximum parallel runlength
		token = LefNextToken(f, TRUE);	// "PARALLELRUNLENTTH"
		entries = 0;
		while (1) {
		    token = LefNextToken(f, TRUE);
		    if (*token == ';' || !strcmp(token, "WIDTH"))
			break;
		    else
			entries++;
		}
		if (*token != ';')
		    newrule = (lefSpacingRule *)malloc(sizeof(lefSpacingRule));

		while (*token != ';') {
		    token = LefNextToken(f, TRUE);	// Minimum width value
		    sscanf(token, "%lg", &dvalue);
		    newrule->width = dvalue / (double)oscale;

		    for (i = 0; i < entries; i++) {
			token = LefNextToken(f, TRUE);	// Spacing value
		    }
		    sscanf(token, "%lg", &dvalue);
		    newrule->spacing = dvalue / (double)oscale;
		    token = LefNextToken(f, TRUE);

		    for (testrule = lefl->info.route.spacing; testrule;
				testrule = testrule->next)
			if (testrule->next == NULL || testrule->next->width >
				newrule->width)
			    break;

		    if (!testrule) {
			newrule->next = NULL;
			lefl->info.route.spacing = newrule;
		    }
		    else {
			newrule->next = testrule->next;
			testrule->next = newrule;
		    }
		    token = LefNextToken(f, TRUE);
		    if (strcmp(token, "WIDTH")) break;
		}
		break;
	    case LEF_LAYER_PITCH:
		token = LefNextToken(f, TRUE);
		sscanf(token, "%lg", &dvalue);
		lefl->info.route.pitchx = dvalue / (double)oscale;

		token = LefNextToken(f, TRUE);
		if (token && (*token != ';')) {
		    sscanf(token, "%lg", &dvalue);
		    lefl->info.route.pitchy = dvalue / (double)oscale;
		    LefEndStatement(f);
		}
		else {
		    lefl->info.route.pitchy = lefl->info.route.pitchx;
		    /* If the orientation is known, then zero the pitch	*/
		    /* in the opposing direction.  If not, then set the	*/
		    /* direction to DIR_RESOLVE so that the pitch in	*/
		    /* the opposing direction can be zeroed when the	*/
		    /* direction is specified.				*/

		    if (lefl->info.route.hdirection == DIR_UNKNOWN)
			lefl->info.route.hdirection = DIR_RESOLVE;
		    else if (lefl->info.route.hdirection == DIR_VERTICAL)
			lefl->info.route.pitchy = 0.0;
		    else if (lefl->info.route.hdirection == DIR_HORIZONTAL)
			lefl->info.route.pitchx = 0.0;
		}

		/* Offset default is 1/2 the pitch.  Offset is		*/
		/* intialized to -1 to tell whether or not the value	*/
		/* has been set by an OFFSET statement.			*/
		if (lefl->info.route.offsetx < 0.0)
		    lefl->info.route.offsetx = lefl->info.route.pitchx / 2.0;
		if (lefl->info.route.offsety < 0.0)
		    lefl->info.route.offsety = lefl->info.route.pitchy / 2.0;
		break;
	    case LEF_LAYER_DIRECTION:
		token = LefNextToken(f, TRUE);
		LefLower(token);
		if (lefl->info.route.hdirection == DIR_RESOLVE) {
		    if (token[0] == 'h')
			lefl->info.route.pitchx = 0.0;
		    else if (token[0] == 'v')
			lefl->info.route.pitchy = 0.0;
		}
		lefl->info.route.hdirection = (token[0] == 'h') ? DIR_HORIZONTAL
				: DIR_VERTICAL;
		LefEndStatement(f);
		break;
	    case LEF_LAYER_OFFSET:
		token = LefNextToken(f, TRUE);
		sscanf(token, "%lg", &dvalue);
		lefl->info.route.offsetx = dvalue / (double)oscale;

		token = LefNextToken(f, TRUE);
		if (token && (*token != ';')) {
		    sscanf(token, "%lg", &dvalue);
		    lefl->info.route.offsety = dvalue / (double)oscale;
		    LefEndStatement(f);
		}
		else {
		    lefl->info.route.offsety = lefl->info.route.offsetx;
		}
		break;
	    case LEF_LAYER_RES:
		token = LefNextToken(f, TRUE);
		if (lefl->lefClass == CLASS_ROUTE) {
		    if (!strcmp(token, "RPERSQ")) {
			token = LefNextToken(f, TRUE);
			sscanf(token, "%lg", &dvalue);
			// Units are ohms per square
			lefl->info.route.respersq = dvalue;
		    }
		}
		else if (lefl->lefClass == CLASS_VIA || lefl->lefClass == CLASS_CUT) {
		    sscanf(token, "%lg", &dvalue);
		    lefl->info.via.respervia = dvalue;	// Units ohms
		}
		LefEndStatement(f);
		break;
	    case LEF_LAYER_CAP:
		token = LefNextToken(f, TRUE);
		if (lefl->lefClass == CLASS_ROUTE) {
		    if (!strcmp(token, "CPERSQDIST")) {
			token = LefNextToken(f, TRUE);
			sscanf(token, "%lg", &dvalue);
			// Units are pF per squared unit length
			lefl->info.route.areacap = dvalue / 
				((double)oscale * (double)oscale);
		    }
		}
		LefEndStatement(f);
		break;
	    case LEF_LAYER_EDGECAP:
		token = LefNextToken(f, TRUE);
		if (lefl->lefClass == CLASS_ROUTE) {
		    sscanf(token, "%lg", &dvalue);
		    // Units are pF per unit length
		    lefl->info.route.edgecap = dvalue / (double)oscale;
		}
		LefEndStatement(f);
		break;
	    case LEF_LAYER_THICKNESS:
	    case LEF_LAYER_HEIGHT:
		/* Assuming thickness and height are the same thing? */
		token = LefNextToken(f, TRUE);
		if (lefl->lefClass == CLASS_ROUTE) {
		    sscanf(token, "%lg", &dvalue);
		    // Units of length
		    lefl->info.route.thick = dvalue / (double)oscale;
		}
		LefEndStatement(f);
		break;
	    case LEF_LAYER_ANTENNA:
	    case LEF_LAYER_ANTENNASIDE:
	    case LEF_LAYER_AGG_ANTENNA:
	    case LEF_LAYER_AGG_ANTENNASIDE:
		/* NOTE: Assuming that only one of these methods will	*/
		/* be used!  If more than one is present, then only the	*/
		/* last one will be recorded and used.			*/

		token = LefNextToken(f, TRUE);
		if (lefl->lefClass == CLASS_ROUTE) {
		    sscanf(token, "%lg", &dvalue);
		    // Unitless values (ratio)
		    lefl->info.route.antenna = dvalue;
		}
		if (keyword == LEF_LAYER_ANTENNA)
		    lefl->info.route.method = CALC_AREA;
		else if (keyword == LEF_LAYER_ANTENNASIDE)
		    lefl->info.route.method = CALC_SIDEAREA;
		else if (keyword == LEF_LAYER_AGG_ANTENNA)
		    lefl->info.route.method = CALC_AGG_AREA;
		else
		    lefl->info.route.method = CALC_AGG_SIDEAREA;
		LefEndStatement(f);
		break;
	    case LEF_LAYER_ANTENNADIFF:
	    case LEF_LAYER_AGG_ANTENNADIFF:
		/* Not specifically handling these antenna types */
		/* (antenna ratios for antennas connected to diodes,	*/
		/* which can still blow gates if the diode area is	*/
		/* insufficiently large.)				*/
		LefEndStatement(f);
		break;
	    case LEF_LAYER_MINDENSITY:
	    case LEF_LAYER_WIREEXT:
		/* Not specifically handling these */
		LefEndStatement(f);
		break;
	    case LEF_VIA_DEFAULT:
	    case LEF_VIARULE_GENERATE:
		/* Do nothing; especially, don't look for end-of-statement! */
		break;
	    case LEF_VIA_LAYER:
		curlayer = LefReadLayer(f, FALSE);
		LefEndStatement(f);
		break;
	    case LEF_VIA_RECT:
		if (curlayer >= 0)
		    LefAddViaGeometry(f, lefl, curlayer, oscale);
		LefEndStatement(f);
		break;
	    case LEF_VIA_ENCLOSURE:
		/* Defines how to draw via metal layers.	    */
		/* Note that values can interact with ENCLOSURE	    */	
		/* values given for the cut layer type.  This is    */
		/* not being handled.				    */
		{
		    DSEG viarect, encrect;
		    encrect = LefReadEnclosure(f, curlayer, oscale);
		    viarect = (DSEG)malloc(sizeof(struct dseg_));
		    *viarect = *encrect;
		    viarect->next = lefl->info.via.lr;
		    lefl->info.via.lr = viarect;
		}
		if (mode == LEF_SECTION_VIARULE)
		    lefl->info.via.generated = TRUE;
		LefEndStatement(f);
		break;
	    case LEF_VIARULE_OVERHANG:
	    case LEF_VIARULE_METALOVERHANG:
		/* These are from older LEF definitions (e.g., 5.4)	*/
		/* and cannot completely specify via geometry.  So if	*/
		/* seen, ignore the rest of the via section.  Only the	*/
		/* explicitly defined VIA types will be used.		*/
		LefError(LEF_WARNING, "NOTE:  Old format VIARULE ignored.\n");
		lefl->lefClass == CLASS_IGNORE;
		LefEndStatement(f);
		/* LefSkipSection(f, lname); */  /* Continue parsing */
		break;
	    case LEF_VIA_PREFERENCLOSURE:
		/* Ignoring this. */
		LefEndStatement(f);
		break;
	    case LEF_VIARULE_VIA:
		LefEndStatement(f);
		break;
	    case LEF_LAYER_END:
		if (!LefParseEndStatement(f, lname))
		{
		    LefError(LEF_ERROR, "Layer END statement missing.\n");
		    keyword = -1;
		}
		break;
	}
	if (keyword == LEF_LAYER_END) break;
    }
}

/*
 *------------------------------------------------------------
 *
 * LefRead --
 *
 *	Read a .lef file and generate all routing configuration
 *	structures and values from the LAYER, VIA, and MACRO sections
 *
 * Results:
 *	None.
 *
 * Side Effects:
 *	Many.  Cell definitions are created and added to
 *	the GateInfo database.
 *
 *------------------------------------------------------------
 */

/* See above for "enum lef_sections {...}" */

int
LefRead(inName)
    char *inName;
{
    FILE *f;
    char filename[256];
    char *token;
    char tsave[128];
    int keyword, layer;
    int oprecis = 100;	// = 1 / manufacturing grid (microns)
    float oscale;
    double xydiff, ogrid, minwidth;
    LefList lefl;
    DSEG grect;
    GATE gateginfo;

    static char *sections[] = {
	"VERSION",
	"BUSBITCHARS",
	"DIVIDERCHAR",
	"MANUFACTURINGGRID",
	"USEMINSPACING",
	"CLEARANCEMEASURE",
	"NAMESCASESENSITIVE",
	"PROPERTYDEFINITIONS",
	"UNITS",
	"LAYER",
	"VIA",
	"VIARULE",
	"SPACING",
	"SITE",
	"PROPERTY",
	"NOISETABLE",
	"CORRECTIONTABLE",
	"IRDROP",
	"ARRAY",
	"TIMING",
	"BEGINEXT",
	"MACRO",
	"END",
	NULL
    };

    if (!strrchr(inName, '.'))
	sprintf(filename, "%s.lef", inName);
    else
	strcpy(filename, inName);

    f = fopen(filename, "r");

    if (f == NULL)
    {
	fprintf(stderr, "Cannot open input file: ");
	perror(filename);
	return 0;
    }

    if (Verbose > 0) {
	fprintf(stdout, "Reading LEF data from file %s.\n", filename);
	fflush(stdout);
    }

    oscale = 1;

    LefHashInit();

    while ((token = LefNextToken(f, TRUE)) != NULL)
    {
	keyword = Lookup(token, sections);
	if (keyword < 0)
	{
	    LefError(LEF_WARNING, "Unknown keyword \"%s\" in LEF file; ignoring.\n",
			token);
	    LefEndStatement(f);
	    continue;
	}
	switch (keyword)
	{
	    case LEF_VERSION:
	    case LEF_DIVIDERCHAR:
	    case LEF_CLEARANCEMEASURE:
	    case LEF_USEMINSPACING:
	    case LEF_NAMESCASESENSITIVE:
		LefEndStatement(f);
		break;
	    case LEF_BUSBITCHARS:
		token = LefNextToken(f, TRUE);
		delimiter = (*token == '\"') ? *(token + 1) : *token;
		LefEndStatement(f);
		break;
	    case LEF_MANUFACTURINGGRID:
		token = LefNextToken(f, TRUE);
		if (sscanf(token, "%lg", &ogrid) == 1)
		    oprecis = (int)((1.0 / ogrid) + 0.5);
		LefEndStatement(f);
		break;
	    case LEF_PROPERTYDEFS:
		LefSkipSection(f, sections[LEF_PROPERTYDEFS]);
		break;
	    case LEF_UNITS:
		LefSkipSection(f, sections[LEF_UNITS]);
		break;

	    case LEF_SECTION_VIA:
	    case LEF_SECTION_VIARULE:
		token = LefNextToken(f, TRUE);
		sprintf(tsave, "%.127s", token);

		lefl = LefFindLayer(token);

		if (keyword == LEF_SECTION_VIARULE) {
		    char *vianame = (char *)malloc(strlen(token) + 3);
		    sprintf(vianame, "%s_0", token);

		    /* If the following keyword is GENERATE, then	*/
		    /* prepare up to four contact types to represent	*/
		    /* all possible orientations of top and bottom	*/
		    /* metal layers.  If no GENERATE keyword, ignore.	*/

		    token = LefNextToken(f, TRUE);
		    if (!strcmp(token, "GENERATE")) {
			lefl = LefNewVia(vianame);
			lefl->next = LefInfo;
			LefInfo = lefl;
			LefReadLayerSection(f, tsave, keyword, lefl);
		    }
		    else {
			LefSkipSection(f, tsave);
		    }
		    free(vianame);
		}
		else if (lefl == NULL)
		{
		    lefl = LefNewVia(token);
		    lefl->next = LefInfo;
		    LefInfo = lefl;
		    LefReadLayerSection(f, tsave, keyword, lefl);
		}
		else
		{
		    LefError(LEF_WARNING, "Warning:  Cut type \"%s\" redefined.\n",
				token);
		    lefl = LefRedefined(lefl, token);
		    LefReadLayerSection(f, tsave, keyword, lefl);
		}
		break;

	    case LEF_SECTION_LAYER:
		token = LefNextToken(f, TRUE);
		sprintf(tsave, "%.127s", token);
	
		lefl = LefFindLayer(token);	
		if (lefl == (LefList)NULL)
		{
		    lefl = LefNewRoute(token);
		    lefl->next = LefInfo;
		    LefInfo = lefl;
		}
		else
		{
		    if (lefl && lefl->type < 0)
		    {
			LefError(LEF_ERROR, "Layer %s is only defined for"
					" obstructions!\n", token);
			LefSkipSection(f, tsave);
			break;
		    }
		}
		LefReadLayerSection(f, tsave, keyword, lefl);
		break;

	    case LEF_SECTION_SPACING:
		LefSkipSection(f, sections[LEF_SECTION_SPACING]);
		break;
	    case LEF_SECTION_SITE:
		token = LefNextToken(f, TRUE);
		if (Verbose > 0)
		    fprintf(stdout, "LEF file:  Defines site %s\n", token);
		sprintf(tsave, "site_%.122s", token);
		LefReadMacro(f, tsave, oscale);
		break;
	    case LEF_PROPERTY:
		LefSkipSection(f, NULL);
		break;
	    case LEF_NOISETABLE:
		LefSkipSection(f, sections[LEF_NOISETABLE]);
		break;
	    case LEF_CORRECTIONTABLE:
		LefSkipSection(f, sections[LEF_CORRECTIONTABLE]);
		break;
	    case LEF_IRDROP:
		LefSkipSection(f, sections[LEF_IRDROP]);
		break;
	    case LEF_ARRAY:
		LefSkipSection(f, sections[LEF_ARRAY]);
		break;
	    case LEF_SECTION_TIMING:
		LefSkipSection(f, sections[LEF_SECTION_TIMING]);
		break;
	    case LEF_EXTENSION:
		LefSkipSection(f, sections[LEF_EXTENSION]);
		break;
	    case LEF_MACRO:
		token = LefNextToken(f, TRUE);
		/* Diagnostic */
		/*
		fprintf(stdout, "LEF file:  Defines new cell %s\n", token);
		*/
		sprintf(tsave, "%.127s", token);
		LefReadMacro(f, tsave, oscale);
		break;
	    case LEF_END:
		if (!LefParseEndStatement(f, "LIBRARY"))
		{
		    LefError(LEF_ERROR, "END statement out of context.\n");
		    keyword = -1;
		}
		break;
	}
	if (keyword == LEF_END) break;
    }
    if (Verbose > 0) {
	fprintf(stdout, "LEF read: Processed %d lines.\n", lefCurrentLine);
	LefError(LEF_ERROR, NULL);	/* print statement of errors, if any */
    }

    /* Cleanup */
    if (f != NULL) fclose(f);

    /* Make sure that the gate list has one entry called "pin" */

    for (gateginfo = GateInfo; gateginfo; gateginfo = gateginfo->next)
	if (!strcasecmp(gateginfo->gatename, "pin"))
	    break;

    if (!gateginfo) {
	/* Add a new GateInfo entry for pseudo-gate "pin" */
	gateginfo = (GATE)malloc(sizeof(struct gate_));
	gateginfo->gatetype = NULL;
	gateginfo->gateclass = MACRO_CLASS_DEFAULT;
	gateginfo->gatesubclass = MACRO_SUBCLASS_NONE;
	gateginfo->gatename = (char *)malloc(4);
	strcpy(gateginfo->gatename, "pin");
	gateginfo->width = 0.0;
	gateginfo->height = 0.0;
	gateginfo->placedX = 0.0;
	gateginfo->placedY = 0.0;
	gateginfo->nodes = 1;

        gateginfo->taps = (DSEG *)malloc(sizeof(DSEG));
        gateginfo->noderec = (NODE *)malloc(sizeof(NODE));
        gateginfo->area = (float *)malloc(sizeof(float));
        gateginfo->direction = (u_char *)malloc(sizeof(u_char));
        gateginfo->use = (u_char *)malloc(sizeof(u_char));
        gateginfo->netnum = (int *)malloc(sizeof(int));
        gateginfo->node = (char **)malloc(sizeof(char *));

	grect = (DSEG)malloc(sizeof(struct dseg_));
	grect->x1 = grect->x2 = 0.0;
	grect->y1 = grect->y2 = 0.0;
	grect->next = (DSEG)NULL;
	gateginfo->obs = (DSEG)NULL;
	gateginfo->next = GateInfo;
	gateginfo->last = (GATE)NULL;
	gateginfo->taps[0] = grect;
        gateginfo->noderec[0] = NULL;
        gateginfo->area[0] = 0.0;
        gateginfo->netnum[0] = -1;
	gateginfo->node[0] = strdup("pin");
	gateginfo->clientdata = (void *)NULL;
	GateInfo = gateginfo;

	LefHashMacro(gateginfo);
    }
    return oprecis;
}
