#=========================================================================
# ReqAckBundle.py
#=========================================================================
# Defines a PortBundle for the ReqAck interface.

from pymtl     import *
from reqack    import reqack_to_str

#-------------------------------------------------------------------------
# ReqAckBundle
#-------------------------------------------------------------------------
# Definition for the ReqAck PortBundle.
class ReqAckBundle( PortBundle ):

  #-----------------------------------------------------------------------
  # __init__
  #-----------------------------------------------------------------------
  # Interface for the ReqAck PortBundle.
  def __init__( self, nbits ):
    self.msg = InPort ( nbits )
    self.req = InPort ( 1 )
    self.ack = OutPort( 1 )

  #-----------------------------------------------------------------------
  # to_str
  #-----------------------------------------------------------------------
  def to_str( self, msg=None ):
    msg = self.msg if (msg==None) else msg
    return reqack_to_str( msg, self.req, self.ack )

  #-----------------------------------------------------------------------
  # __str__
  #-----------------------------------------------------------------------
  def __str__( self ):
    return reqack_to_str( self.msg, self.req, self.ack )

#-------------------------------------------------------------------------
# Create InReqAckBundle and OutReqAckBundle
#-------------------------------------------------------------------------
InReqAckBundle, OutReqAckBundle = create_PortBundles( ReqAckBundle )
