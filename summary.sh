#!/usr/bin/bash

echo "Enter Branch Name (Eg. Branch4)"
read branch
echo "Enter Month Number (Eg. 07 or 11)"
read num

history=($(find /home -type f -path "*$branch/*" -name 'Transaction_History.txt'))
his=${#history[@]}
Date=$(date +%F)

declare -A arr
declare -A a1

for (( c=0; c<$his ; c++ ))
do
  month=($(grep "+" ${history[$c]} | awk '{print $3}' | cut -d- -f2))
  am=($(grep "+" ${history[$c]} | awk '{print $2}' | tr -d +))
  mon=${#month[@]}
  var=0
  for (( d=0; d<$mon ; d++ ))
  do
    if [ "${month[$d]}" -eq "$num" ];
    then
      arr[$c,$d]=${am[$d]}
      var=$(echo $var+${am[$d]} | bc)
    else
      arr[$c,$d]=0
      var=$(echo $var+0 | bc)
    fi
  done
  a1[$c]=$var
done

IFS=$'\n'
top=$(echo "${arr[*]}" | sort -nr | head -n1)

for (( c=0; c<$his ; c++ ))
do
  month=($(grep "+" ${history[$c]} | awk '{print $3}'))
  mon=${#month[@]}
  for (( d=0; d<$mon ; d++ ))
  do
    if [[ "$top" == 0 ]];
    then
       echo "No Clear Answer for most deposited" >> /home/$branch/$Date
       break 2
    elif [[ "${arr[$c,$d]}" == "$top" ]];
    then
       dep=$(grep "+" ${history[$c]} | awk '{print $1}' | sort --unique)
      echo "Most Deposited: $dep" >> /home/$branch/$Date
    fi
  done
done

declare -A brr
declare -A b1

for (( c=0; c<$his ; c++ ))
do
  month=($(grep " -" ${history[$c]} | awk '{print $3}' | cut -d- -f2))
  am=($(grep " -" ${history[$c]} | awk '{print $2}' | tr -d -))
  mon=${#month[@]}
  var=0
  for (( d=0; d<$mon ; d++ ))
  do
    if [ "${month[$d]}" -eq "$num" ];
    then
      brr[$c,$d]=${am[$d]}
      var=$(echo $var+${am[$d]} | bc)
    else
      brr[$c,$d]=0
      var=$(echo $var+0 | bc)
    fi
  done
  b1[$c]=$var
done

IFS=$'\n'
top=$(echo "${brr[*]}" | sort -nr | head -n1)

for (( c=0; c<$his ; c++ ))
do
  month=($(grep "-" ${history[$c]} | awk '{print $3}'))
  mon=${#month[@]}
  for (( d=0; d<$mon ; d++ ))
  do
    if [[ "$top" == 0 ]];
    then
       echo "No Clear Answer for most Withdrawn" >> /home/$branch/$Date
       break 2
    elif [[ "${brr[$c,$d]}" == "$top" ]];
    then
       with=$(grep "-" ${history[$c]} | awk '{print $1}' | sort --unique)
       echo "Most Withdrawn: $with" >> /home/$branch/$Date
    fi
  done
done

for (( c=0; c<$his ; c++ ))
do
  c1[$c]=$(echo ${a1[$c]}-${b1[$c]} | bc)
done

c2=${#c1[@]}
sum=0
for (( c=0; c<$c2 ; c++ ))
do
  sum=$(echo " $sum + ${c1[$c]} " | bc)
done
mean=$(bc -l <<< " $sum / $c2 ")
echo "Mean: $mean" >> /home/$branch/$Date


c3=($(echo "${c1[*]}" | sort -nr))
if [[ "($c2 % 2)" == 0 ]]; then
  median=$(echo " ${c3[$c2/2]} + ${c3[($c2/2)+1]} " | bc)
else
  median=${c3[($c2/2)]}
fi
echo "Median: $median" >> /home/$branch/$Date

mode=$(echo ${c1[@]} | xargs -n1 echo | sort | uniq --count | sort -n | tail -n1 | awk '{ print $2 }')
echo "Mode: $mode" >> /home/$branch/$Date

