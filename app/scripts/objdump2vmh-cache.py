#!/usr/bin/env python
#===============================================================================
# objdump2vmh.py
#===============================================================================
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#  -f --file     Objdump file to parse
#
# Author : Ji Kim
# Date   : April 13, 2011
#

import optparse
import fileinput
import sys
import re
import math

#-------------------------------------------------------------------------------
# Command line processing
#-------------------------------------------------------------------------------

class OptionParserWithCustomError(optparse.OptionParser):
  def error( self, msg = "" ):
    if ( msg ): print("\n ERROR: %s" % msg)
    print("")
    for line in fileinput.input(sys.argv[0]):
      if ( not re.match( "#", line ) ): sys.exit(msg != "")
      if ((fileinput.lineno() == 3) or (fileinput.lineno() > 4)):
        print( re.sub( "^#", "", line.rstrip("\n") ) )

def parse_cmdline():
  p = OptionParserWithCustomError( add_help_option=False )
  p.add_option( "-v", "--verbose", action="store_true", dest="verbose" )
  p.add_option( "-h", "--help",    action="store_true", dest="help" )
  p.add_option( "-f", "--file",    action="store", type="string", dest="file" )
  (opts,args) = p.parse_args()
  if ( help == True ): p.error()
  if args: p.error("found extra positional arguments")
  return opts

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  # Open vmh file for writing
  file_out = open( opts.file[0:opts.file.find( "." )] + "-cache.vmh", "w" )

  # Number of words in a cache line
  cache_line_nwords = 4

  # Initialization
  counter = 0
  PC_last = '00000000'

  try:

    # Open objdump file for reading
    file_in = open( opts.file, "r" )

    try:

      in_block = False

      # Iterate through lines in the file
      for line in file_in:

        # Parse the line into a list of words
        split_line = line.split()

        # Check if line is the beginning of an instruction block
        if ( line.find( ">:\n" ) >= 0 ):

          #print 'BLOCK:'

          in_block = True

          # Number of bits to shift to get cache line identifier
          tag_shamt = 2 + int( math.log( cache_line_nwords, 2 ) )

          #print 'shamt = {0}'.format( tag_shamt )

          # Check if current address is in previous cache line
          PC_current = split_line[0]

          PC_current_int = int( PC_current, 16 )
          tag_current    = PC_current_int >> tag_shamt
          idx_current    = ( PC_current_int >> 2 ) % cache_line_nwords

          #print 'PC_current = {0}'.format( PC_current )
          #print 'tag_current = {0}'.format( tag_current )
          #print 'idx_current = {0}'.format( idx_current )

          PC_last_int = int( PC_last, 16 )
          tag_last    = PC_last_int >> tag_shamt
          idx_last    = ( PC_last_int >> 2 ) % cache_line_nwords

          #print 'PC_last = {0}'.format( PC_last )
          #print 'tag_last = {0}'.format( tag_last )
          #print 'idx_last = {0}'.format( idx_last )

          tag_match = ( tag_current == tag_last )

          #print 'match? {0}'.format( tag_match )

          # Still part of previous cache line
          if ( tag_match ):

            #print 'counter_before = {0}'.format( counter )
            num_nops = idx_current - idx_last - 1
            buffer = ( '00000000' * num_nops ) + buffer
            counter = counter + num_nops
            #print 'counter_after = {0}'.format( counter )

          # Start new cache line
          else:

            # Fill out rest of previous cache line if necessary
            if ( counter > 0 ):
              buffer = ( '00000000' * ( cache_line_nwords - counter ) ) + buffer + "\n"
              counter = 0
              file_out.write( buffer )

            # Convert block virtual address to physical address (cache-line size = 128b)
            block_addr = hex( tag_current )[2:]

            # Construct vmh line to write
            buffer = "\n@" + block_addr + "\n"

            # Write to vmh file
            file_out.write( buffer )

        # Check if line is within an instruction block
        elif ( in_block ):

          # Unset in_block if there's a break
          if ( line == "\n" ):

            in_block = False

          else:

            # Parse instruction field
            inst_bits = split_line[1]

            # Remember current PC
            PC_raw = split_line[0][:-1]
            zero_amt = 8 - len( PC_raw )
            PC_last = ( "0" * zero_amt ) + PC_raw

            # Initialize buffer with first word of data
            if ( counter == 0 ):
              buffer = inst_bits

            # Insert additional words in cache line in little-endian order
            else:
              buffer = inst_bits + buffer

            # Insert newline at the end of each cache line
            if ( counter == cache_line_nwords - 1 ):
              buffer = buffer + "\n"
              counter = 0

              # Write line to vmh
              file_out.write( buffer )

            # Increment counter
            else:
              counter = counter + 1

    finally:

      # Fill out any remaining cache lines and write to vmh
      if ( counter > 0 ):
        buffer = ( '00000000' * ( cache_line_nwords - counter ) ) + buffer + "\n"
        file_out.write( buffer )

      file_in.close()

  finally:

    file_out.close()

main()

