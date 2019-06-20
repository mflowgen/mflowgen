/*
 * readlef.h --
 *
 * This file defines things that are used by internal LEF routines in
 * various files.
 *
 */

#ifndef _READLEF_H
#define _READLEF_H

#include "lef.h"

#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif

/* Some constants for LEF and DEF files */

#define LEF_LINE_MAX 2048  /* Maximum length fixed by LEF/DEF specifications */
#define LEF_MAX_ERRORS 100 /* Max # errors to report; limits output if */
                           /* something is really wrong about the file */

#define DEFAULT_WIDTH 3	   /* Default metal width for routes if undefined */
#define DEFAULT_SPACING 4  /* Default spacing between metal if undefined  */

/* Structure holding the counts of regular and special nets */

typedef struct
{
    int regular;
    int special;
    u_char has_nets;
} NetCount;

/* Various modes for writing nets. */
#define DO_REGULAR  0
#define DO_SPECIAL  1
#define ALL_SPECIAL 2	/* treat all nets as SPECIALNETS */

/* Types of error messages */
enum lef_error_types {LEF_ERROR = 0, LEF_WARNING, DEF_ERROR, DEF_WARNING};

/* Macro classes */
enum macro_classes {MACRO_CLASS_DEFAULT = 0, MACRO_CLASS_CORE,
	MACRO_CLASS_BLOCK, MACRO_CLASS_PAD, MACRO_CLASS_RING,
	MACRO_CLASS_COVER, MACRO_CLASS_ENDCAP};

/* Core macro subclasses */
enum macro_subclasses {MACRO_SUBCLASS_NONE = 0,
	MACRO_SUBCLASS_SPACER, MACRO_SUBCLASS_ANTENNA,
	MACRO_SUBCLASS_WELLTAP, MACRO_SUBCLASS_TIEHIGH,
	MACRO_SUBCLASS_TIELOW, MACRO_SUBCLASS_FEEDTHRU};

/* Port classes */
enum port_classes {PORT_CLASS_DEFAULT = 0, PORT_CLASS_INPUT,
	PORT_CLASS_OUTPUT, PORT_CLASS_TRISTATE, PORT_CLASS_BIDIRECTIONAL,
        PORT_CLASS_FEEDTHROUGH};

/* Port uses */
enum port_uses {PORT_USE_DEFAULT = 0, PORT_USE_SIGNAL,
        PORT_USE_ANALOG, PORT_USE_POWER, PORT_USE_GROUND,
        PORT_USE_CLOCK, PORT_USE_TIEOFF, PORT_USE_SCAN,
	PORT_USE_RESET};

/* Structure to hold information about spacing rules */
typedef struct _lefSpacingRule *lefSpacingPtr;
typedef struct _lefSpacingRule {
    lefSpacingPtr next;
    double width;	/* width, in microns */
    double spacing;	/* minimum spacing rule, in microns */
} lefSpacingRule;

/* Area calculation methods for finding antenna ratios.  ANTENNA_ROUTE	*/
/* is not a method but is used to indicate to the antenna search	*/
/* routine that the search is for routing preparation and not for	*/
/* calculating error.							*/

enum area_methods {CALC_NONE = 0, CALC_AREA, CALC_SIDEAREA, CALC_AGG_AREA,
	CALC_AGG_SIDEAREA, ANTENNA_ROUTE, ANTENNA_DISABLE};

/* Structure used to maintain default routing information for each	*/
/* routable layer type.							*/

typedef struct {
    lefSpacingRule *spacing;	/* spacing rules, ordered by width */
    double width;	/* nominal route width, in microns */
    double pitchx;	/* route X pitch, in microns */
    double pitchy;	/* route Y pitch, in microns */
    double offsetx;	/* route track offset from X origin, in microns */
    double offsety;	/* route track offset from Y origin, in microns */
    double respersq;	/* resistance per square */
    double areacap;	/* area capacitance per square micron */
    double edgecap;	/* edge capacitance per micron */
    double minarea;	/* minimum metal area rule */
    double thick;	/* metal layer thickness, if given */
    double antenna;	/* antenna area ratio rule */
    u_char method;	/* antenna rule calculation method */ 
    u_char hdirection;	/* horizontal direction preferred */
} lefRoute;

/* These values may be used for "hdirection".  initialize hdirection	*/
/* with DIR_UNKNOWN.  If the LEF file defines the pitch before the 	*/
/* direction and does not specify both X and Y pitches, then change to	*/
/* DIR_RESOLVE to indicate that the pitch in the non-preferred		*/
/* direction should be zeroed when the preferred direction is known.	*/

#define DIR_VERTICAL	(u_char)0
#define DIR_HORIZONTAL	(u_char)1
#define DIR_UNKNOWN	(u_char)2
#define DIR_RESOLVE	(u_char)3

/* Structure used to maintain default generation information for each	*/
/* via or viarule (contact) type.  If "cell" is non-NULL, then the via	*/
/* is saved in a cell (pointed to by "cell"), and "area" describes the	*/
/* bounding box.  Otherwise, the via is formed by magic type "type"	*/
/* with a minimum area "area" for a single contact.			*/

typedef struct {
    lefSpacingRule *spacing;	/* spacing rules, ordered by width	*/
    struct dseg_ area;		/* Area of single contact, or cell bbox	*/
				/* in units of microns			*/
    GATE	cell;		/* Cell for fixed via def, or NULL	*/
    DSEG	lr;		/* Extra information for vias with	*/
				/* more complicated geometry.		*/
    double      respervia;	/* resistance per via			*/
    int		obsType;	/* Secondary obstruction type		*/
    char	generated;	/* Flag indicating via from VIARULE	*/
} lefVia;

/* Defined types for "lefClass" in the lefLayer structure */
/* Note that the first four match TYPE records in the LEF.  IGNORE has	*/
/* a special meaning to qrouter, and VIA is for VIA definitions.	*/

#define CLASS_ROUTE	0	/* route layer */
#define CLASS_CUT	1	/* cut layer */
#define CLASS_MASTER	2	/* masterslice layer */
#define CLASS_OVERLAP	3	/* overlap layer */
#define CLASS_IGNORE	4	/* inactive layer */
#define CLASS_VIA	5	/* via record */

/* Structure defining a route or via layer and matching it to a magic	*/
/* layer type.  This structure is saved in the LefInfo list.		*/

typedef struct _lefLayer *LefList;

typedef struct _lefLayer {
    LefList next;	/* Next layer in linked list */
    char *lefName;	/* CIF name of this layer */
    int	  type;		/* GDS layer type, or -1 for none */
    int	  obsType;	/* GDS type to use if this is an obstruction */
    u_char lefClass;	/* is this a via, route, or masterslice layer */
    union {
	lefRoute   route;	/* for route layers */
	lefVia	   via;		/* for contacts */
    } info;
} lefLayer;

/* External declaration of global variables */
extern int lefCurrentLine;
extern LefList LefInfo;
extern LinkedStringPtr AllowedVias;

/* Forward declarations */

int   Lookup(char *str, char*(table[]));

u_char LefParseEndStatement(FILE *f, char *match);
void  LefSkipSection(FILE *f, char *match);
void  LefEndStatement(FILE *f);
GATE  lefFindCell(char *name);
char *LefNextToken(FILE *f, u_char ignore_eol);
char *LefLower(char *token);
DSEG  LefReadGeometry(GATE lefMacro, FILE *f, float oscale);
LefList LefRedefined(LefList lefl, char *redefname);
void LefAddViaGeometry(FILE *f, LefList lefl, int curlayer, float oscale);
DSEG LefReadRect(FILE *f, int curlayer, float oscale);
int  LefReadLayer(FILE *f, u_char obstruct);
LefList LefFindLayer(char *token);
LefList LefFindLayerByNum(int layer);
LefList LefNewVia(char *name);
int    LefFindLayerNum(char *token);
void   LefSetRoutePitchX(int layer, double value);
void   LefSetRoutePitchY(int layer, double value);
double LefGetViaWidth(LefList lefl, int layer, int dir);
double LefGetRouteKeepout(int layer);
double LefGetRouteWidth(int layer);
double LefGetRouteMinArea(int layer);
double LefGetRouteSpacing(int layer);
double LefGetRouteWideSpacing(int layer, double width);
double LefGetRoutePitch(int layer);
double LefGetRoutePitchX(int layer);
double LefGetRoutePitchY(int layer);
double LefGetRouteOffset(int layer);
double LefGetRouteThickness(int layer);
double LefGetRouteAreaRatio(int layer);
u_char LefGetRouteAntennaMethod(int layer);
int    LefGetRouteRCvalues(int layer, double *areacap, double *edgecap,
		double *respersq);
int    LefGetViaResistance(int layer, double *respervia);
char  *LefGetRouteName(int layer);
int    LefGetRouteOrientation(int layer);
int    LefGetMaxRouteLayer(void);
int    LefGetMaxLayer(void);

GATE   LefFindInstance(char *name);
void   LefHashCell(GATE gateginfo);

int    LefRead(char *inName);
void   LefAssignLayerVias();
void   LefWriteGeneratedVias(FILE *f, double oscale, int defvias);


void LefError(int type, char *fmt, ...);	/* Variable argument procedure */
						/* requires parameter list. */

#endif /* _READLEF_H */
