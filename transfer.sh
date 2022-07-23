#!/usr/bin/bash

echo "Enter Account Name(Eg. ACC0001)"
read acc
echo "Enter Bank Account(Eg. Branch1)"
read bank
var=$(awk -v field=3 '{print $field}' /home/$acc/$bank/Current_Balance.txt)
echo "Deposit/Withdraw: "
read transfer
echo "Quantity to be withdrawn/Deposited"
read amount
Date=$(date +%F)
Time=$(date +%T)
if [[ "$transfer" == "Withdraw" ]]; then
   if [[ "$var" -ge "$amount" ]]; then
     new=$(( $var - $amount ))
     echo "Total Balance: $new" > /home/$acc/$bank/Current_Balance.txt
     echo "$acc -$amount $Date $Time" >> /home/$acc/$bank/Transaction_History.txt
   else
     echo "Amount to be withdrawn is less than current balance"
   fi
elif [[ "$transfer" == "Deposit" ]]; then
   new1=$(( $var + $amount ))
   echo "Total Balance: $new1" > /home/$acc/$bank/Current_Balance.txt
   echo "$acc +$amount $Date $Time" >> /home/$acc/$bank/Transaction_History.txt
fi

