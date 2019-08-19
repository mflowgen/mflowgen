#! /usr/bin/env python
#=========================================================================
# letters.py
#=========================================================================
# Print big letters adapted from the 'Ivrit' font of the figlet package.
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#  -c --color    Print in color
#  -t --text     Text to print big
#     --all      Do not truncate the text length
#
# Author : Christopher Torng
# Date   : June 12, 2019
#

#-------------------------------------------------------------------------
# License file for the figlet package
#-------------------------------------------------------------------------
# Copyright (C) 1991, 1993, 1994 Glenn Chappell and Ian Chai
# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001 John Cowan
# Copyright (C) 2002 Christiaan Keet
# Copyright (C) 2011 Claudio Matsuoka
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holders nor the names of their
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

from __future__ import print_function
import argparse
import sys

#-------------------------------------------------------------------------
# Command line processing
#-------------------------------------------------------------------------

class ArgumentParserWithCustomError(argparse.ArgumentParser):
  def error( self, msg = "" ):
    if ( msg ): print( "\n ERROR: %s" % msg )
    print()
    file = open( sys.argv[0] )
    for ( lineno, line ) in enumerate( file ):
      if ( line[0] != '#' ): sys.exit(msg != "")
      if ( (lineno == 2) or (lineno >= 4) ): print( line[1:].rstrip("\n") )

def parse_cmdline():
  p = ArgumentParserWithCustomError( add_help=False )
  p.add_argument( "-v", "--verbose", action="store_true" )
  p.add_argument( "-h", "--help",    action="store_true" )
  p.add_argument( "-c", "--color",   action="store_true" )
  p.add_argument( "-t", "--text",    default="foo"       )
  p.add_argument(       "--all",     action="store_true" )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Letters
#-------------------------------------------------------------------------

letters = {}

letters['A'] = [
  "    _    ",
  "   / \   ",
  "  / _ \  ",
  " / ___ \ ",
  "/_/   \_\\",
  "         ",
]
letters['B'] = [
  " ____  ",
  "| __ ) ",
  "|  _ \ ",
  "| |_) |",
  "|____/ ",
  "       ",
]
letters['C'] = [
  "  ____ ",
  " / ___|",
  "| |    ",
  "| |___ ",
  " \____|",
  "       ",
]
letters['D'] = [
  " ____  ",
  "|  _ \ ",
  "| | | |",
  "| |_| |",
  "|____/ ",
  "       ",
]
letters['E'] = [
  " _____ ",
  "| ____|",
  "|  _|  ",
  "| |___ ",
  "|_____|",
  "       ",
]
letters['F'] = [
  " _____ ",
  "|  ___|",
  "| |_   ",
  "|  _|  ",
  "|_|    ",
  "       ",
]
letters['G'] = [
  "  ____ ",
  " / ___|",
  "| |  _ ",
  "| |_| |",
  " \____|",
  "       ",
]
letters['H'] = [
  " _   _ ",
  "| | | |",
  "| |_| |",
  "|  _  |",
  "|_| |_|",
  "       ",
]
letters['I'] = [
  " ___ ",
  "|_ _|",
  " | | ",
  " | | ",
  "|___|",
  "     ",
]
letters['J'] = [
  "     _ ",
  "    | |",
  " _  | |",
  "| |_| |",
  " \___/ ",
  "       ",
]
letters['K'] = [
  " _  __",
  "| |/ /",
  "| ' / ",
  "| . \ ",
  "|_|\_\\",
  "      ",
]
letters['L'] = [
  " _     ",
  "| |    ",
  "| |    ",
  "| |___ ",
  "|_____|",
  "       ",
]
letters['M'] = [
  " __  __ ",
  "|  \/  |",
  "| |\/| |",
  "| |  | |",
  "|_|  |_|",
  "        ",
]
letters['N'] = [
  " _   _ ",
  "| \ | |",
  "|  \| |",
  "| |\  |",
  "|_| \_|",
  "       ",
]
letters['O'] = [
  "  ___  ",
  " / _ \ ",
  "| | | |",
  "| |_| |",
  " \___/ ",
  "       ",
]
letters['P'] = [
  " ____  ",
  "|  _ \ ",
  "| |_) |",
  "|  __/ ",
  "|_|    ",
  "       ",
]
letters['Q'] = [
  "  ___  ",
  " / _ \ ",
  "| | | |",
  "| |_| |",
  " \__\_\\",
  "       ",
]
letters['R'] = [
  " ____  ",
  "|  _ \ ",
  "| |_) |",
  "|  _ < ",
  "|_| \_\\",
  "       ",
]
letters['S'] = [
  " ____  ",
  "/ ___| ",
  "\___ \ ",
  " ___) |",
  "|____/ ",
  "       ",
]
letters['T'] = [
  " _____ ",
  "|_   _|",
  "  | |  ",
  "  | |  ",
  "  |_|  ",
  "       ",
]
letters['U'] = [
  " _   _ ",
  "| | | |",
  "| | | |",
  "| |_| |",
  " \___/ ",
  "       ",
]
letters['V'] = [
  "__     __",
  "\ \   / /",
  " \ \ / / ",
  "  \ V /  ",
  "   \_/   ",
  "         ",
]
letters['W'] = [
  "__        __",
  "\ \      / /",
  " \ \ /\ / / ",
  "  \ V  V /  ",
  "   \_/\_/   ",
  "            ",
]
letters['X'] = [
  "__  __",
  "\ \/ /",
  " \  / ",
  " /  \ ",
  "/_/\_\\",
  "      ",
]
letters['Y'] = [
  "__   __",
  "\ \ / /",
  " \ V / ",
  "  | |  ",
  "  |_|  ",
  "       ",
]
letters['Z'] = [
  " _____",
  "|__  /",
  "  / / ",
  " / /_ ",
  "/____|",
  "      ",
]

#-------------------------------------------------------------------------

letters['a'] = [
  "       ",
  "  __ _ ",
  " / _` |",
  "| (_| |",
  " \__,_|",
  "       ",
]
letters['b'] = [
  " _     ",
  "| |__  ",
  "| '_ \ ",
  "| |_) |",
  "|_.__/ ",
  "       ",
]
letters['c'] = [
  "      ",
  "  ___ ",
  " / __|",
  "| (__ ",
  " \___|",
  "      ",
]
letters['d'] = [
  "     _ ",
  "  __| |",
  " / _` |",
  "| (_| |",
  " \__,_|",
  "       ",
]
letters['e'] = [
  "      ",
  "  ___ ",
  " / _ \\",
  "|  __/",
  " \___|",
  "      ",
]
letters['f'] = [
  "  __ ",
  " / _|",
  "| |_ ",
  "|  _|",
  "|_|  ",
  "     ",
]
letters['g'] = [
  "       ",
  "  __ _ ",
  " / _` |",
  "| (_| |",
  " \__, |",
  " |___/ ",
]
letters['h'] = [
  " _     ",
  "| |__  ",
  "| '_ \ ",
  "| | | |",
  "|_| |_|",
  "       ",
]
letters['i'] = [
  " _ ",
  "(_)",
  "| |",
  "| |",
  "|_|",
  "   ",
]
letters['j'] = [
  "     ",
  "   _ ",
  "  (_)",
  "  | |",
  " _/ |",
  "|__/ ",
]
letters['k'] = [
  " _    ",
  "| | __",
  "| |/ /",
  "|   < ",
  "|_|\_\\",
  "      ",
]
letters['l'] = [
  " _ ",
  "| |",
  "| |",
  "| |",
  "|_|",
  "   ",
]
letters['m'] = [
  "           ",
  " _ __ ___  ",
  "| '_ ` _ \ ",
  "| | | | | |",
  "|_| |_| |_|",
  "           ",
]
letters['n'] = [
  "       ",
  " _ __  ",
  "| '_ \ ",
  "| | | |",
  "|_| |_|",
  "       ",
]
letters['o'] = [
  "       ",
  "  ___  ",
  " / _ \ ",
  "| (_) |",
  " \___/ ",
  "       ",
]
letters['p'] = [
  "       ",
  " _ __  ",
  "| '_ \ ",
  "| |_) |",
  "| .__/ ",
  "|_|    ",
]
letters['q'] = [
  "       ",
  "  __ _ ",
  " / _` |",
  "| (_| |",
  " \__, |",
  "    |_|",
]
letters['r'] = [
  "      ",
  " _ __ ",
  "| '__|",
  "| |   ",
  "|_|   ",
  "      ",
]
letters['s'] = [
  "     ",
  " ___ ",
  "/ __|",
  "\__ \\",
  "|___/",
  "     ",
]
letters['t'] = [
  " _   ",
  "| |_ ",
  "| __|",
  "| |_ ",
  " \__|",
  "     ",
]
letters['u'] = [
  "       ",
  " _   _ ",
  "| | | |",
  "| |_| |",
  " \__,_|",
  "       ",
]
letters['v'] = [
  "       ",
  "__   __",
  "\ \ / /",
  " \ V / ",
  "  \_/  ",
  "       ",
]
letters['w'] = [
  "          ",
  "__      __",
  "\ \ /\ / /",
  " \ V  V / ",
  "  \_/\_/  ",
  "          ",
]
letters['x'] = [
  "      ",
  "__  __",
  "\ \/ /",
  " >  < ",
  "/_/\_\\",
  "      ",
]
letters['y'] = [
  "       ",
  " _   _ ",
  "| | | |",
  "| |_| |",
  " \__, |",
  " |___/ ",
]
letters['z'] = [
  "     ",
  " ____",
  "|_  /",
  " / / ",
  "/___|",
  "     ",
]

#-------------------------------------------------------------------------

letters['1'] = [
  " _ ",
  "/ |",
  "| |",
  "| |",
  "|_|",
  "   ",
]
letters['2'] = [
  " ____  ",
  "|___ \ ",
  "  __) |",
  " / __/ ",
  "|_____|",
  "       ",
]
letters['3'] = [
  " _____ ",
  "|___ / ",
  "  |_ \ ",
  " ___) |",
  "|____/ ",
  "       ",
]
letters['4'] = [
  " _  _   ",
  "| || |  ",
  "| || |_ ",
  "|__   _|",
  "   |_|  ",
  "        ",
]
letters['5'] = [
  " ____  ",
  "| ___| ",
  "|___ \ ",
  " ___) |",
  "|____/ ",
  "       ",
]
letters['6'] = [
  "  __   ",
  " / /_  ",
  "| '_ \ ",
  "| (_) |",
  " \___/ ",
  "       ",
]
letters['7'] = [
  " _____ ",
  "|___  |",
  "   / / ",
  "  / /  ",
  " /_/   ",
  "       ",
]
letters['8'] = [
  "  ___  ",
  " ( _ ) ",
  " / _ \ ",
  "| (_) |",
  " \___/ ",
  "       ",
]
letters['9'] = [
  "  ___  ",
  " / _ \ ",
  "| (_) |",
  " \__, |",
  "   /_/ ",
  "       ",
]
letters['0'] = [
  "  ___  ",
  " / _ \ ",
  "| | | |",
  "| |_| |",
  " \___/ ",
  "       ",
]

#-------------------------------------------------------------------------

letters[' '] = [
  "   ",
  "   ",
  "   ",
  "   ",
  "   ",
  "   ",
]
letters['.'] = [
  "   ",
  "   ",
  "   ",
  " _ ",
  "(_)",
  "   ",
]
letters[','] = [
  "   ",
  "   ",
  " _ ",
  "( )",
  "|/ ",
  "   ",
]
letters['!'] = [
  " _ ",
  "| |",
  "| |",
  "|_|",
  "(_)",
  "   ",
]
letters['@'] = [
  "   ____  ",
  "  / __ \ ",
  " / / _` |",
  "| | (_| |",
  " \ \__,_|",
  "  \____/ ",
]
letters['#'] = [
  "   _  _   ",
  " _| || |_ ",
  "|_  ..  _|",
  "|_      _|",
  "  |_||_|  ",
  "          ",
]
letters['$'] = [
  "  _  ",
  " | | ",
  "/ __)",
  "\__ \\",
  "(   /",
  " |_| ",
]
letters['%'] = [
  " _  __",
  "(_)/ /",
  "  / / ",
  " / /_ ",
  "/_/(_)",
  "      ",
]
letters['^'] = [
  " /\ ",
  "|/\|",
  "    ",
  "    ",
  "    ",
  "    ",
]
letters['&'] = [
  "  ___   ",
  " ( _ )  ",
  " / _ \/\\",
  "| (_>  <",
  " \___/\/",
  "        ",
]
letters['*'] = [
  "      ",
  "__/\__",
  "\    /",
  "/_  _\\",
  "  \/  ",
  "      ",
]
letters['('] = [
  "  __ ",
  " / / ",
  "| |  ",
  "| |  ",
  " \_\ ",
  "     ",
]
letters[')'] = [
  " __  ",
  " \ \ ",
  "  | |",
  "  | |",
  " /_/ ",
  "     ",
]
letters['-'] = [
  "        ",
  "        ",
  " ______ ",
  "|______|",
  "        ",
  "        ",
]
letters['_'] = [
  "        ",
  "        ",
  "        ",
  " ______ ",
  "|______|",
  "        ",
]
letters['+'] = [
  "       ",
  "   _   ",
  " _| |_ ",
  "|_   _|",
  "  |_|  ",
  "       ",
]
letters['='] = [
  "        ",
  " ______ ",
  "|______|",
  "|______|",
  "        ",
  "        ",
]
letters['/'] = [
  "    __",
  "   / /",
  "  / / ",
  " / /  ",
  "/_/   ",
  "      ",
]
letters['\\'] = [
  "__    ",
  "\ \   ",
  " \ \  ",
  "  \ \ ",
  "   \_\\",
  "      ",
]
letters['{'] = [
  "   __",
  "  / /",
  " | | ",
  "< <  ",
  " | | ",
  "  \_\\",
]
letters['}'] = [
  "__   ",
  "\ \  ",
  " | | ",
  "  > >",
  " | | ",
  "/_/  ",
]
letters['['] = [
  " __ ",
  "| _|",
  "| | ",
  "| | ",
  "| | ",
  "|__|",
]
letters[']'] = [
  " __ ",
  "|_ |",
  " | |",
  " | |",
  " | |",
  "|__|",
]
letters['<'] = [
  "  __",
  " / /",
  "/ / ",
  "\ \ ",
  " \_\\",
  "    ",
]
letters['>'] = [
  "__  ",
  "\ \ ",
  " \ \\",
  " / /",
  "/_/ ",
  "    ",
]
letters['?'] = [
  " ___ ",
  "|__ \\",
  "  / /",
  " |_| ",
  " (_) ",
  "     ",
]
letters['|'] = [
  " _ ",
  "| |",
  "| |",
  "| |",
  "| |",
  "|_|",
]
letters['`'] = [
  " _ ",
  "( )",
  " \|",
  "   ",
  "   ",
  "   ",
]
letters['\''] = [
  " _ ",
  "( )",
  "|/ ",
  "   ",
  "   ",
  "   ",
]
letters['"'] = [
  " _ _ ",
  "( | )",
  " V V ",
  "     ",
  "     ",
  "     ",
]
letters[';'] = [
  " _ ",
  "(_)",
  " _ ",
  "( )",
  "|/ ",
  "   ",
]
letters[':'] = [
  "   ",
  " _ ",
  "(_)",
  " _ ",
  "(_)",
  "   ",
]
letters['~'] = [
  "     ",
  "     ",
  " /\/|",
  "|/\/ ",
  "     ",
  "     ",
]

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  if not opts.all and len(opts.text) > 14:
    text = opts.text[:3] + ' .. ' + opts.text[-11:]
  else:
    text = opts.text

  echo_green   = '\033[92m'
  echo_nocolor = '\033[0m'

  height = 6

  errors = set()

  if opts.color: print( echo_green )
  for i in range( height ):
    for l in text:
      if l not in letters.keys():
        errors.add( 'Error: No data for character "%s"' % l )
        continue
      print( letters[l][i], end=' ' )
    print()
  if opts.color: print( echo_nocolor )

  for e in errors:
    print( e )

main()

