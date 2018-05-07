#!/bin/bash

DESIGN_NAME=${design_name}

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
  py.test ../${DESIGN_NAME}/${DESIGN_NAME}_test.py -k $p -v

  # add the case to the test case
  echo "task "$p";"        >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  echo "begin"             >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  cat  ${DESIGN_NAME}_testcase_init.v >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  echo "end"               >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  echo "endtask"           >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  echo ""                  >> ${CURRENT_FOLDER}/${DESIGN_NAME}_all_tests.v
  rm -f ${DESIGN_NAME}_testcase_init.v

  # add the task to dispatch function

  q=$(echo $p | sed s/"\["/_/g | sed s/"-"/_/g | sed s/"]"//g)

  if [ ${flag} -eq 0 ]; then
    echo "  if      (name == \"$p\") " $q"();" >> temp_dispatch.v
    flag=1
  else
    echo "  else if (name == \"$p\") " $q"();" >> temp_dispatch.v
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
