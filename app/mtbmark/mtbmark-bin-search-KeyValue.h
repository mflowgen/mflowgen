//========================================================================
// ubmark-bin-search-KeyValue
//========================================================================
// KeyValue structure for binary search kernel

#ifndef MTBMARK_BIN_SERACH_KEYVALUE_H
#define MTBARK_BIN_SERACH_KEYVALUE_H

//------------------------------------------------------------------------
// Key/Value pair struct
//------------------------------------------------------------------------

struct KeyValue
{
  KeyValue() : key(0), value(0) { }
  KeyValue( int key_, int value_ ) : key(key_), value(value_) { }

  int key;
  int value;
};

inline
bool operator<( const KeyValue& lhs, const KeyValue& rhs )
{
  return ( lhs.key < rhs.key );
}

inline
bool operator==( const KeyValue& lhs, const KeyValue& rhs )
{
  return ( lhs.key == rhs.key );
}

#endif /*UBMARK_BIN_SEARCH_KEYVALUE_H*/
