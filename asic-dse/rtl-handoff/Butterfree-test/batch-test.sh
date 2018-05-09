#!/bin/bash

make test-rtl
rm -f test.log

while read p; do # execute test one by one
  echo "[BRG]" $p | tee -a test.log

  ./test-rtl +test=$p | grep BRG | tee -a test.log

done < list-test-case.txt

