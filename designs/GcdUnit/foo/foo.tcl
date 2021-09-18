# Test intent-implementation splits

proc mflowgen.implement.blockA {} {
  return [ list INV_X1 INV_X2 INV_X8 ]
}

proc mflowgen.intent.blockA { a b c } {
  puts "hello world $a $b $c"

  array set mflowgen.property.invx8 {
    property "c=='INV_X8'"
    describe "c must be invx8 because..."
  }

  array set mflowgen.property.sum_is_2 {
    property "c+a==2"
    describe "c and a sum must be 2 because..."
  }

}

mflowgen.intent.blockA {*}[ mflowgen.implement.blockA ]

# Test distributed checks

proc mflowgen.distributed.blockA {} {
  return [ list hello world ]
}

proc mflowgen.distributed.blockB {} {
  return [ list this sentence does not match ]
}


