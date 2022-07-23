#!/usr/bin/bash

echo "File/Input"
read out
if [ "$out" == "File" ];
then
  echo "Enter file name/path"
  read file
  lines=($(wc -l $file))
  a=($(awk '{for (i=1;i<NF;i++) if ($i~"ACC") print $i}' $file))
  b=($(awk '{for (j=1;j<NF;j++) if ($j~"Branch") print $j}' $file))

  for (( c=0; c<$lines; c++ ))
  do
   sudo useradd -m -d /home/${a[$c]} ${a[$c]}
   sudo mkdir -p /home/${a[$c]}/${b[$c]}
   sudo echo "Total Balance: 500" >  /home/${a[$c]}/${b[$c]}/Current_Balance.txt
   sudo chmod o-rwx /home/${a[$c]}/${b[$c]}/Current_Balance.txt
   sudo touch /home/${a[$c]}/${b[$c]}/Transaction_History.txt
   sudo chmod o-rwx /home/${a[$c]}/${b[$c]}/Transaction_History.txt
   d=$((c +1 ))
   awk -v line=$d 'NR==line{print $0}' $file |  grep -o "citizen\|resident\|foreigner\|minor\|seniorCitizen\|legacy" > /home/${a[$c]}/${b[$c]}/ACC_Details.txt
   sudo chmod o-rwx /home/${a[$c]}/${b[$c]}/ACC_Details.txt
  done

elif [ "$out" == "Input" ]; then
 echo "Type of Account(Account/Branch Manager/CEO)"
 read type
 if [ "$type" == "Account" ]; then
  echo "Enter Account Number(Eg. ACC001)"
  read number
  echo "Enter Branch Number(Eg. Branch1)"
  read branch
  echo "Please enter some additional bank information"
  echo "(citizen/resident/foreigner)"
  read det1
  echo "(seniorCitizen/minor)"
  read det2
  echo "Do you have a legacy account?(Y/N)"
  read det3

  sudo useradd -m -d /home/$number $number
  sudo mkdir -p /home/$number/$branch
  sudo echo "Total Balance: 500" >  /home/$number/$branch/Current_Balance.txt
  sudo chmod o-rwx /home/$number/$branch/Current_Balance.txt
  sudo touch /home/$number/$branch/Transaction_History.txt
  sudo chmod o-rwx /home/$number/$branch/Transaction_History.txt
  if [ "$det3" == "Y" ]; then
    echo "$det1 $det2 legacy " > /home/$number/$branch/ACC_Details.txt
  else
    echo "$det1 $det2 " > /home/$number/$branch/ACC_Details.txt
  fi
  sudo chmod o-rwx /home/$number/$branch/ACC_Details.txt


 elif [ "$type" == "Branch Manager" ]; then
  echo "Enter Branch Number"
  read bran
  sudo useradd -m -d /home/$bran $bran
  sudo touch /home/$bran/Branch_Current_Balance.txt
  sudo chmod o-rwx /home/$bran/Branch_Current_Balance.txt
  sudo echo "Account_Number Amount Date Time" > /home/$bran/Branch_Transaction_History.txt
  sudo chmod o-rwx /home/$bran/Branch_Current_Balance.txt
  sudo touch /home/$bran/Daily_Interest_Rates.txt
  sudo chmod o-rwx /home/$bran/Daily_Interest_Rates.txt

 elif [ "$type" == "CEO" ]; then
  echo "Enter CEO Name"
  read name
  sudo useradd -m -d /home/$name $name
 fi
fi
