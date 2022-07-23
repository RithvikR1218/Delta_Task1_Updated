#!/usr/bin/bash

echo "Enter Branch No(Eg. Branch1)"
read branch
a=($(find /home -type f -path "*$branch/*" -name 'Transaction_History.txt'))
b=($(find /home -type f -path "*$branch/*" -name 'Current_Balance.txt'))
d1=0
a1=${#a[@]}
b1=${#b[@]}

#Branch Transaction History Part
echo "Account_Number Amount Date Time" > /home/$branch/Branch_Transaction_History.txt
for (( c=0; c<$a1; c++ ))
do
 cat ${a[$c]} >> /home/$branch/Branch_Transaction_History.txt
done 

#Branch Current Balance Part
for (( c=0; c<$b1; c++ ))
do
 d=($(awk '{print $3}' ${b[$c]}))
done
for (( c=0; c<$b1; c++ ))
do
 d[$c]=$(awk '{print $3}' ${b[$c]}) 
done
for i in ${d[@]}; 
do
 let d1+=$i 
done
echo "Total Balance: $d1" > /home/$branch/Branch_Current_Balance.txt

