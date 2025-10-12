/*--------------------------------------------------------------*/
/* lef.h -- 							*/
/*--------------------------------------------------------------*/

#ifndef _LEF_H
#define _LEF_H

#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

#ifndef _SYS_TYPES_H
#ifndef u_char
typedef unsigned char  u_char;
#endif
#ifndef u_short
typedef unsigned short u_short;
#endif
#ifndef u_int
typedef unsigned int   u_int;
#endif
#ifndef u_long
typedef unsigned long  u_long;
#endif
#endif /* _SYS_TYPES_H */

/* Compare functions aren't defined in the Mac's standard library */
#if defined(__APPLE__)
typedef int (*__compar_fn_t)(const void*, const void*);
#endif

/* Maximum number of route layers */
#define MAX_LAYERS    12

/* Maximum number of all defined layers.  Since masterslice and	*/
/* overlap types are ignored, this just includes all the cuts.	*/
#define MAX_TYPES    (MAX_LAYERS * 2 - 1)

/* Cell name (and other names) max length */
#define MAX_NAME_LEN    1024

/* Max reasonable line length */
#define MAX_LINE_LEN    2048

// define possible gate orientations
// Basic definitions for flipping in X and Y
#define MNONE	0x00
#define MX	0x01
#define MY	0x02

// Complete definition from value in DEF file
#define RN	0x04
#define RS	0x08
#define RE	0x10	
#define RW	0x20
#define RF	0x40

// linked list structure for holding a list of char * strings

typedef struct linkedstring_ *LinkedStringPtr;

typedef struct linkedstring_ {
   char *name;
   LinkedStringPtr next;
} LinkedString;

// structure holding input and output scalefactors

typedef struct scalerec_ {
   int    iscale;
   int	  mscale;
   double oscale;
} ScaleRec;

// Linked string list

typedef struct string_ *STRING;

struct string_ {
   STRING next;
   char *name;
};

/* DSEG is used for gate node and obstruction positions.		*/

typedef struct dseg_ *DSEG;

struct dseg_ {
   DSEG   next;
   int    layer;
   double x1, y1, x2, y2;
};

/* POINT is an integer point in three dimensions (layer giving the	*/
/* vertical dimension).							*/

typedef struct point_ *POINT;

struct point_ {
  POINT next; 
  int layer;
  int x1, y1;
};

/* DPOINT is a point location with  coordinates given *both* as an	*/
/* integer (for the grid-based routing) and as a physical dimension	*/
/* (microns).								*/

typedef struct dpoint_ *DPOINT;

struct dpoint_ {
   DPOINT next;
   int layer;
   double x, y;
   int gridx, gridy;
};

/* BUS is used for keep information about pins that are array components */

typedef struct bus_ *BUS;

struct bus_ {
   BUS  next;
   char *busname;
   int  low;
   int  high;
};

typedef struct node_ *NODE;

struct node_ {
  NODE    next;
  int     nodenum;		// node ordering within its net
  DPOINT  taps;			// point position for node taps
  DPOINT  extend;		// point position within halo of the tap
  char    *netname;   		// name of net this node belongs to
  u_char  numtaps;		// number of actual reachable taps
  int     netnum;               // number of net this node belongs to
  int     numnodes;		// number of nodes on this net
  int	  branchx;		// position of the node branch in x
  int	  branchy;		// position of the node branch in y
};

// these are instances of gates in the netlist.  The description of a 
// given gate (the macro) is held in GateInfo.  The same structure is
// used for both the macro and the instance records.

typedef struct gate_ *GATE;

struct gate_ {
    GATE next;
    GATE last;		// For double-linked list
    char *gatename;	// Name of instance
    GATE  gatetype;	// Pointer to macro record
    u_char gateclass;	// LEF class of gate (CORE, PAD, etc.)
    u_char gatesubclass; // LEF sub-class of gate (SPACER, TIELOW, etc.)
    int   nodes;        // number of nodes on this gate
    char **node;	// names of the pins on this gate
    int   *netnum;	// net number connected to each pin
    NODE  *noderec;	// node record for each pin
    float *area;	// gate area for each pin
    u_char *direction;	// port direction (input, output, etc.)	
    u_char *use;	// pin use (power, ground, etc.)
    DSEG  *taps;	// list of gate node locations and layers
    DSEG   obs;		// list of obstructions in gate
    BUS    bus;		// linked list of buses in the pin list
    double width, height;
    double placedX;                 
    double placedY;
    int orient;
    void *clientdata;	// This space for rent
};

// Define record holding information pointing to a gate and the
// index into a specific node of that gate.

typedef struct gatenode_ *GATENODE;

struct gatenode_ {
    GATE gate;
    int idx;
};

// Structure for a network

typedef struct net_ *NET;

struct net_ {
   int  netnum;		// a unique number for this net
   char *netname;
   NODE netnodes;	// list of nodes connected to the net
   int  numnodes;	// number of nodes connected to the net
   char Flags;		// See flag field definitions, below
};

// Flag definitions for nets

#define NET_SPECIAL 1	// Indicates a net read from SPECIALNETS

// List of nets

typedef struct netlist_ *NETLIST;

struct netlist_ {
   NETLIST next;
   NET net;
};

// Structure for a row definition

typedef struct row_ *ROW;

struct row_ {
    char *rowname;
    char *sitename;
    int x;
    int y;
    int orient;
    int xnum;
    int ynum;
    int xstep;
    int ystep;
};

/* external references to global variables */

extern GATE   GateInfo;		// standard cell macro information
extern GATE   PinMacro;		// macro definition for a pin
extern GATE   Nlgates;
extern NET    *Nlnets;
extern int    Numnets;
extern u_char Verbose;

/* Function prototypes */

#endif /* _LEF_H */
