#=========================================================================
# draw.py
#=========================================================================
# Generates a list of coordinates to draw polygons based on an ascii
# drawing.
#
# The list of coordinates looks like this:
#
#     set logo_shapes [list \
#       [ list 10 10 ] \
#       [ list 30 30 ] \
#     ]
#
#
# Author : Christopher Torng
# Date   : May 16, 2018
#

# shapes
#
# The shapes array should look like this:
#
#     shapes = [
#       'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
#       'xxxxxxxx        xxxxxxx       xxxxxxxx        xxxx',
#       'xxxxxxx   xxxx   xxxxxxxx   xxxxxxxx    xxxx   xxx',
#       'xxxxxx   xxx   xxxxxxxxx   xxxxxxx    xxxxxxx  xxx',
#       'xxxxx       xxxxxxxxxxx   xxxxxxx    xxxxxxxxxxxxx',
#       'xxxx   xxx   xxxxxxxxx   xxxxxxxx    xxx       xxx',
#       'xxx   xxxx    xxxxxxx   xxxxxxxxxx    xxxxx   xxxx',
#       'xx          xxxxxxx       xxxxxxxxxx        xxxxxx',
#       'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
#     ]
#
# or this:
#
#     shapes = [
#       'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
#       'xxxxxxxx          xxxxx        xxxxxxx       xxxxx',
#       'xxxxxxx   xxxxxxxxxxx    xxx   xxxxx    xxx   xxxx',
#       'xxxxxx   xxxxxxxxxx    xxxx   xxxx    xxxx   xxxxx',
#       'xxxxx        xxxxx    xxxx   xxxx    xxxx   xxxxxx',
#       'xxxx   xxxxxxxxxx    xxx    xxxx    xxx    xxxxxxx',
#       'xxx   xxxxxxxxxx    xx    xxxxx    xx    xxxxxxxxx',
#       'xx   xxxxxxxxxxxx       xxxxxxxx       xxxxxxxxxxx',
#       'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
#     ]
#

from shapes import shapes

origin_x = 0
origin_y = 0

width = 5
pad   = int( 0.6 * width )
shift = int( 0.2 * width )

with open( 'shapes.tcl', 'w' ) as f:
  f.write( 'set logo_shapes [list \\\n' )
  for y, line in enumerate(reversed(shapes)):
    for x, c in enumerate(line):
      if c == 'x':
        x_c = origin_x + x * ( width + pad ) + y * shift
        y_c = origin_y + y * ( width + pad )
        f.write( '  [ list ' + str(x_c) + ' ' + str(y_c) + ' ] \\\n' )
  f.write( ']\n' )


