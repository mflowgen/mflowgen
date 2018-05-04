#!/bin/bash

make test-rtl
rm -f test.log

while read p; do # execute test one by one
  echo "[BRG]" $p >> test.log

  ./test-rtl +test=$p | grep BRG >> test.log

done < list-test-case.txt

