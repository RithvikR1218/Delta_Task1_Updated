#!/usr/bin/bash

echo "Enter Branch Name (Eg. Branch4)"
read branch
a=$(find /home -type f -path "*$branch/*" -name 'Daily_Interest_Rates.txt')

minor=$(grep "minor" $a | awk '{print $2}' | tr -d %)
seniorCitizen=$(grep "seniorCitizen" $a | awk '{print $2}' | tr -d %)
foreigner=$(grep "foreigner" $a | awk '{print $2}' | tr -d %)
resident=$(grep "resident" $a | awk '{print $2}' | tr -d %)
citizen=$(grep "citizen" $a | awk '{print $2}' | tr -d %)
legacy=$(grep "legacy" $a | awk '{print $2}' | tr -d %)

details=($(find /home -type f -path "*$branch/*" -name 'ACC_Details.txt'))
balance=($(find /home -type f -path "*$branch/*" -name 'Current_Balance.txt'))
history=($(find /home -type f -path "*$branch/*" -name 'Transaction_History.txt'))
ACC=($(find /home -type f -path "*$branch/*" -name 'Transaction_History.txt'| cut -d/ -f3))

det=${#details[@]}
bal=${#balance[@]}

Date=$(date +%F)
Time=$(date +%T)

for (( c=0; c<$bal ; c++ ))
do
   amount[$c]=$(awk '{print $3}' ${balance[$c]})
done
for (( c=0 ; c<$det ; c++ ))
do
  grep -q minor "${details[$c]}"
  if [ $? -eq 0 ];
  then
    a1=$(echo "${amount[$c]} * $minor" | bc)
  else
    a1=0
  fi
  grep -q citizen "${details[$c]}"
  if [ $? -eq 0 ];
  then
    b1=$(echo "${amount[$c]} * $citizen" | bc)
  else
    b1=0
  fi
  grep -q legacy "${details[$c]}"
  if [ $? -eq 0 ];
  then
    c1=$(echo "${amount[$c]} * $legacy" | bc)
  else
    c1=0
  fi
  grep -q resident "${details[$c]}"
  if [ $? -eq 0 ];
  then
    d1=$(echo "${amount[$c]} * $resident" | bc)
  else
    d1=0
  fi
  grep -q seniorCitizen "${details[$c]}"
  if [ $? -eq 0 ];
  then
    e1=$(echo "${amount[$c]} * $seniorCitizen" | bc)
  else
    e1=0
  fi
  grep -q foreigner "${details[$c]}"
  if [ $? -eq 0 ];
  then
    f1=$(echo "${amount[$c]} * $foreigner" | bc)
  else
    f1=0
  fi
  sum=$(echo "$a1 + $b1 + $c1 + $d1 + $e1 + $f1 + ${amount[$c]}" | bc)
  sum1=$(echo "$sum - ${amount[$c]}" | bc)
  echo "Total Balance: $sum" >  ${balance[$c]}
  echo "${ACC[$c]} +$sum1 $Date $Time" > ${history[$c]}
done
