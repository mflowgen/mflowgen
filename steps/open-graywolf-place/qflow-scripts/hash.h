#ifndef _HASH_H
#define _HASH_H

#define TINYHASHSIZE  17
#define SMALLHASHSIZE 997
#define LARGEHASHSIZE 99997

struct hashlist {
  char *name;
  void *ptr;
  struct hashlist *next;
};

struct hashtable {
    int hashsize;
    int hashfirstindex;			/* for iterating through table */
    struct hashlist *hashfirstptr;	/* ditto */
    struct hashlist **hashtab;		/* this is the actual table */
};

extern void InitializeHashTable(struct hashtable *table, int hashsize);
extern int RecurseHashTable(struct hashtable *table,
	int (*func)(struct hashlist *elem));
extern int RecurseHashTableValue(struct hashtable *table,
	int (*func)(struct hashlist *elem, int), int);
extern struct nlist *RecurseHashTablePointer(struct hashtable *table,
	struct nlist *(*func)(struct hashlist *elem, 
	void *), void *pointer);

extern int CountHashTableEntries(struct hashlist *p);
extern int CountHashTableBinsUsed(struct hashlist *p);
extern void HashDelete(char *name, struct hashtable *table);
extern void HashIntDelete(char *name, int value, struct hashtable *table);
extern void HashKill(struct hashtable *table);

/* these functions return a pointer to a hash list element */
extern struct hashlist *HashInstall(char *name, struct hashtable *table);
extern struct hashlist *HashPtrInstall(char *name, void *ptr, 
		struct hashtable *table);
extern struct hashlist *HashIntPtrInstall(char *name, int value, void *ptr, 
		struct hashtable *table);

/* these functions return the ->ptr field of a struct hashtable */
extern void *HashLookup(char *s, struct hashtable *table);
extern void *HashIntLookup(char *s, int i, struct hashtable *table);
extern void *HashFirst(struct hashtable *table);
extern void *HashNext(struct hashtable *table);

extern unsigned long hashnocase(char *s, int);
extern unsigned long hash(char *s, int);

extern int (*matchfunc)(char *, char *);
/* matchintfunc() compares based on the name and the first	*/
/* entry of the pointer value, which is cast as an integer	*/
extern int (*matchintfunc)(char *, char *, int, int);
extern unsigned long (*hashfunc)(char *, int);

/* the matching functions themselves */
extern int match(char *s1, char *s2);
extern int matchnocase(char *s1, char *s2);

#endif /* _HASH_H */
