#=========================================================================
# edge.py
#=========================================================================
# Author : Christopher Torng
# Date   : June 2, 2019
#

class Edge:

  def __init__( s, src, dst ):
    s.src = src
    s.dst = dst

  def get_src( s ):
    return s.src

  def get_dst( s ):
    return s.dst


