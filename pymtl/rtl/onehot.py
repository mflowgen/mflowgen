#=======================================================================
# onehot.py
#=======================================================================

from pymtl import *

#-----------------------------------------------------------------------
# Mux
#-----------------------------------------------------------------------
class Mux( Model ):

  def __init__( s, nports, dtype ):

    s.sel = InPort ( nports )
    s.in_ = [ InPort( dtype ) for _ in range( nports ) ]
    s.out = OutPort( dtype )

    @s.combinational
    def logic():
      s.out.value = 0
      if not s.sel:
        s.out.value = 0
      else:
        for i in range( nports ):
          if s.sel[i]:
            s.out.value = s.in_[i]

  def line_trace( s ):
    str_ = ' | '.join( ['{} {}'.format( s.sel[i], in_ ) for i, in_
                        in enumerate( s.in_ ) ] )
    str_ += ' () {}'.format( s.out )
    return str_

#-----------------------------------------------------------------------
# Demux
#-----------------------------------------------------------------------
class Demux( Model ):

  def __init__( s, nports, dtype ):

    s.sel = InPort( nports )
    s.in_ = InPort( dtype )
    s.out = [ OutPort( dtype ) for _ in range( nports ) ]

    @s.combinational
    def logic():
      for i in range( nports ):
        s.out[i].value = s.in_ if s.sel[i] else 0

  def line_trace( s ):
    str_  = '{} {} () '.format( s.sel, s.in_ )
    str_ += ' | '.join( ['{}'.format( x ) for x in s.out ] )
    return str_
