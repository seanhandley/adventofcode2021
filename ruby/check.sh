#!/usr/bin/env bash

FILE=error.txt

function test {
  RET=0
  pushd "day_$1" > /dev/null
  FILE="output$1.$2.txt"
  EXPECTED=$(cat $FILE)
  CMD="./advent$1.$2.rb"
  ACTUAL=$(cat input.txt | $CMD)

  if [[ $EXPECTED == $ACTUAL ]]
  then echo "DAY $1.$2 OK"
  else echo "DAY $1.$2 FAIL"; echo "EXPECTED: \n'$EXPECTED'"; echo "ACTUAL: \n'$ACTUAL'"; RET=-1
  fi

  popd > /dev/null
  if [[ $RET < 0 ]]
  then echo "$RET" > error.txt
  fi
}

START=$(date +%s)

echo "Running tests:"
echo ""

for i in {1..11}
do
  for j in {1..2}
  do
    test $i $j &
  done
done

wait

END=$(date +%s)

RUNTIME=$((END-START))

echo ""
echo "Completed in $RUNTIME second(s)."

if [[ -f "$FILE" ]]; then
  rm $FILE
  exit 1
fi
