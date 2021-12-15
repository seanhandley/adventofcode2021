#!/usr/bin/env bash

FILE=error.txt

function test {
  if [ ! -d "day_$1" ]; then
    exit
  fi
  RET=0
  pushd "day_$1" > /dev/null
  FILE="output$1.$2.txt"
  EXPECTED=$(cat $FILE)
  CMD="bundle exec advent$1.$2.rb"
  ACTUAL=$(cat input.txt | $CMD)

  if [[ $EXPECTED == $ACTUAL ]]
  then echo "DAY $1.$2 OK" >> ../results.txt
  else echo "DAY $1.$2 FAIL. Expected '$EXPECTED', but got '$ACTUAL'" >> ../results.txt; RET=-1
  fi

  popd > /dev/null
  if [[ $RET < 0 ]]
  then echo "$RET" >> error.txt
  fi
}

START=$(date +%s)

echo "Running tests..."
echo ""

for i in {1..25}
do
  for j in {1..2}
  do
    test $i $j &
  done
done

wait

END=$(date +%s)

RUNTIME=$((END-START))

cat results.txt | sort -V
rm results.txt

ERROR_COUNT=0
if [[ -f "$FILE" ]]; then
  ERROR_COUNT=$(cat error.txt | wc -l | xargs)
fi

echo ""
echo "Completed in $RUNTIME second(s) with $ERROR_COUNT error(s)."

if [[ -f "$FILE" ]]; then
  rm $FILE
  exit 1
fi
