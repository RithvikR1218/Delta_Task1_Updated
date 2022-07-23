#!/usr/bin/bash

echo "Type of User(Account/Branch Manager/CEO)"
read type
if [[ "$type" == "Account" ]]; then
  echo "Enter Account Name(ACC0001)"
  read name
  setfacl -m u:$name:rx -R /home/$name
elif [[ "$type" == "Branch Manager" ]]; then
  echo "Enter Branch Name(Eg. Branch1)"
  read branch
  arr=($(find /home -type d -name "$branch"))
  var=${#arr[@]}
  for (( c=0 ; c<$var ; c++ ))
  do 
    setfacl -m u:$branch:rwx -R ${arr[$c]}
  done
elif [[ "$type" == "CEO" ]]; then
  echo "Name of CEO(Same as User Account)"
  read ceo
  a=($(find /home -type d -name "ACC*"))
  b=($(find /home -type d -name "Branch*"))
  var_a=${#a[@]}
  var_b=${#b[@]}
  for (( c=0 ; c<$var_a ; c++ ))
  do
    setfacl -m u:$ceo:rx -R ${a[$c]}
  done
  for (( c=0 ; c<$var_b ; c++ ))
  do 
    setfacl -m u:$ceo:rwx -R ${b[$c]}
  done
fi
