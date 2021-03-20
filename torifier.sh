#!/bin/bash
clear
echo "
    ████████╗ ██████╗ ██████╗ ██╗███████╗██╗███████╗██████╗ 
    ╚══██╔══╝██╔═══██╗██╔══██╗██║██╔════╝██║██╔════╝██╔══██╗
       ██║   ██║   ██║██████╔╝██║█████╗  ██║█████╗  ██████╔╝
       ██║   ██║   ██║██╔══██╗██║██╔══╝  ██║██╔══╝  ██╔══██╗
       ██║   ╚██████╔╝██║  ██║██║██║     ██║███████╗██║  ██║
       ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
"
sleep 0.5
echo "                                                        
Author: 	rock-dotcom
Creation Date:  20/3-21
Description: 	Torproxy for Ubuntu and Debian Distros 
"

sleep 2

sudo apt update && sudo apt upgrade -f -y

sleep 0.5

clear

sudo apt autoremove -f -y

sleep 0.5

clear
sudo apt install tor -f -y

sleep 0.2

clear


echo "Please set a password to protect your TOR connection:
"
 read -p "Enter password: " NEWPASS

	sleep 1
	#creating config.txt
	sudo echo > config.txt
	sleep 1

 sed -i -e"s/^pass=.*/pass=$NEWPASS/" config.txt

sleep 0.5

torpass=$(tor --hash-password '$NEWPASS')

sleep 2

clear

printf "HashedControlPassword $torpass\nControlPort 9051\n" | sudo tee -a /etc/tor/torrc

echo "
Your connection is now secured with a password 
"
sleep 2

clear

echo "Restarting TOR to apply changes
"
sudo systemctl restart tor

sleep 1

clear

echo "--------------------------------------------------------------
The torified shell will only persist for the current session. 
If you open new terminals or reboot your PC, the shell will 
default back to your ordinary connection.
Do you want to turn torsocks on permanently
for all new shell sessions and after reboot? 
--------------------------------------------------------------
"
sleep 0.5

PS3='
Option = '
q1=("Yes" "No")
select choose in "${q1[@]}"; do
    case $choose in
        "Yes")
            echo "
Turn's torsocks on permanently
		"
sleep 2
source torsocks off 
sleep 2
echo  "
 Modifing ~/.bachrc - Please Wait
"
echo ". torsocks on" >> ~/.bashrc
sleep 2
echo " Restarting TOR - Please Wait
"
sudo systemctl restart tor
sleep 2
echo " Setting torsock on - Please Wait
"
sleep 2
source torsocks on
sleep 2
clear
break ;;
        "No")
clear            
echo "********** .You choose to set torsocks maually. ************** "
	    # optionally call a function or run some code here
           break ;;
        "Quit")
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done

echo "--------------------------------------------------------------
Please use the fallowing commands to activate/deactivate TOR:

$ source torsocks on
(( Tor mode activated )) 

$ source torsocks off
(( Tor mode deactivated ))
" 

echo "             Thank you for using this script.                 "
echo "                    Have a great day!                         "
echo "--------------------------------------------------------------"
sleep 5

exit
