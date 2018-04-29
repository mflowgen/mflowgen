#=========================================================================
# HostAdapter
#=========================================================================
# Author : Shunning Jiang
# Date   : Apr 26, 2018

from pymtl import *

from pclib.ifcs import InValRdyBundle, OutValRdyBundle

class HostAdapter( Model ):

  def __init__( s, req=None, resp=None ):

    # only accept specific req/resp

    assert ( type(req) is InValRdyBundle ) and ( type(resp) is OutValRdyBundle )

    req_type   = req.msg.dtype()
    resp_type  = resp.msg.dtype()

    s.explicit_modulename = "Adapter_{}_{}".format( str(type(req_type).__name__),
                                                    str(type(resp_type).__name__) )

    s.hostreq  = InValRdyBundle( req_type )
    s.realreq  = InValRdyBundle( req_type )
    s.req      = InValRdyBundle( req_type )

    s.hostresp = OutValRdyBundle( resp_type )
    s.realresp = OutValRdyBundle( resp_type )
    s.resp     = OutValRdyBundle( resp_type )

    # Chris Torng think it's weird to connect these inside
    # s.connect( s.req,  req )
    # s.connect( s.resp, resp )

    s.host_en  = InPort( 1 )

    @s.combinational
    def comb_req_select():

      if s.host_en:
        # Mute req
        s.realreq.rdy.value  = 0
        s.realresp.val.value = 0
        s.realresp.msg.value = 0

        # instance.req <- hostreq
        s.req.val.value      = s.hostreq.val
        s.req.msg.value      = s.hostreq.msg
        s.hostreq.rdy.value  = s.req.rdy

        # hostresp <- out_resp
        s.hostresp.val.value = s.resp.val
        s.hostresp.msg.value = s.resp.msg
        s.resp.rdy.value     = s.hostresp.rdy

      else:
        # Mute host
        s.hostreq.rdy.value  = 0
        s.hostresp.val.value = 0
        s.hostresp.msg.value = 0

        # req <- realreq
        s.req.val.value      = s.realreq.val
        s.req.msg.value      = s.realreq.msg
        s.realreq.rdy.value  = s.req.rdy

        # realresp <- resp
        s.realresp.val.value = s.resp.val
        s.realresp.msg.value = s.resp.msg
        s.resp.rdy.value     = s.realresp.rdy

  def line_trace( s ):
    return "(H)" if s.host_en else "( )"
