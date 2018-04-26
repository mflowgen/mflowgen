//========================================================================
// wsrt-Task.inl
//========================================================================

namespace wsrt {

  // In wsrt-Task.h : typedef void (*func_ptr_t) (void*, void*);

  inline LoopTaskRange::LoopTaskRange()
    : m_begin(0), m_end(0)
      { }

  inline LoopTaskRange::LoopTaskRange( int begin, int end )
    : m_begin(begin), m_end(end)
      { }

  inline int LoopTaskRange::size() const
  {
    return m_end - m_begin;
  }

  inline int LoopTaskRange::begin() const
  {
    return m_begin;
  }

  inline int LoopTaskRange::end() const
  {
    return m_end;
  }

  inline bool operator==( const LoopTaskRange& range0, const LoopTaskRange& range1 )
  {
    return ( range0.m_begin == range1.m_begin && range0.m_end == range1.m_end );
  }

  inline TaskDescriptor::TaskDescriptor()
    : m_func_ptr(0), m_args_ptr(0), m_ref_count_ptr(0), m_loop_range( LoopTaskRange() ), m_target_chunk_size(0)
      { }

  inline TaskDescriptor::TaskDescriptor( func_ptr_t func_ptr, void* args_ptr )
    : m_func_ptr(func_ptr), m_args_ptr(args_ptr), m_ref_count_ptr(0), m_loop_range( LoopTaskRange() ), m_target_chunk_size(0)
      { }

}
