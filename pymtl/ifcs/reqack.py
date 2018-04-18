#-------------------------------------------------------------------------
# Utility linetracing function
#-------------------------------------------------------------------------

def reqack_to_str( msg, req, ack ):

  str_   = '{}'.format( msg )
  nchars = len( str_ )

  if       req and     ack: str_ = '<' + str_ + '>'
  if       req and not ack: str_ = '<' + str_ + ' '
  elif not req and     ack: str_ = ' ' + str_ + '>'
  elif not req and not ack: str_ = ' ' + str_ + ' '

  return str_

