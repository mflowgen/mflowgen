#!/bin/bash

DESIGN_NAME=Butterfree

CURRENT_FOLDER=$(pwd)

rm -f ${DESIGN_NAME}_all_tests.v
touch ${DESIGN_NAME}_all_tests.v

mkdir -p ${ALLOY_ASIC_ROOT}/pymtl/build
cd ${ALLOY_ASIC_ROOT}/pymtl/build

rm -f temp_dispatch.v
touch temp_dispatch.v

echo "task ${DESIGN_NAME}_testcase_dispatch(logic [799:0] name);" >> temp_dispatch.v
echo "begin"              >> temp_dispatch.v

# First dump all test cases into tasks

flag=0

while read p; do # execute test one by one
  py.test ../CompButterfree/test/${DESIGN_NAME}_test.py -k $p -v

  # add the case to the test case

  # CT: The test case may contain a period in it, which does not work in
  # Verilog.. so we turn it into a Verilog escaped identifier, which is
  # marked like this "\my.signal ". An escaped identifier is treated as a
  # single signal regardless of periods or other weird characters in it.
  # Note however that you _must_ have a space following the signal, since
  # that is how the compiler knows where the signal ends.

  p=\\$p

  echo "task "$p" ;"       >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  echo "begin"             >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  cat  Butterfree_testcase_init.v >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  echo "end"               >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  echo "endtask"           >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  echo ""                  >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  rm -f Butterfree_testcase_init.v

  # add the task to dispatch function

  q=$(echo $p | sed s/"\["/_/g | sed s/"-"/_/g | sed s/"]"//g)

  if [ ${flag} -eq 0 ]; then
    echo "  if      (name == \"$p\") " $q" ();" >> temp_dispatch.v
    flag=1
  else
    echo "  else if (name == \"$p\") " $q" ();" >> temp_dispatch.v
  fi
  
done < ${CURRENT_FOLDER}/list-test-case.txt

# Append finale

echo "  else begin"           >> temp_dispatch.v
echo "    \$display( \"\" );" >> temp_dispatch.v
echo "    \$display( \"    [BRG] ERROR: test %s doesn't exist\", name );" >> temp_dispatch.v
echo "    \$display( \"\" );" >> temp_dispatch.v
echo "    \$finish(1);"       >> temp_dispatch.v
echo "  end"                  >> temp_dispatch.v
echo "end"                    >> temp_dispatch.v
echo "endtask"                >> temp_dispatch.v
echo ""                       >> temp_dispatch.v

sed -i "s/\[/_/g" ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
sed -i "s/-/_/g"  ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
sed -i "s/]//g"   ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v

cat temp_dispatch.v >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v

rm -f temp_dispatch.v
