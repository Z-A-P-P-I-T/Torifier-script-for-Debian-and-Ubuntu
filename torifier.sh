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
Author: 	rock-dotcom (zappit)
Creation Date:  20/3-21 - modified 10/1-23
Description: 	Torproxy for Ubuntu and Debian Distros bash and zsh shell compatible. 
"

#update environment credentials to avoid asking for credentials everytime
sudo -v

sleep 2

#Update system package
sudo apt update && sudo apt upgrade -f -y

sleep 0.5

clear

#Remove unneeded packages
sudo apt autoremove -f -y

sleep 0.5

clear
#install tor package
sudo apt install tor -f -y

sleep 0.2

clear

echo "Please set a password to protect your TOR connection:"
read -p "Enter password: " NEWPASS

sleep 1

#create config.txt file
sudo echo > config.txt

sleep 1

#update password in config.txt
sed -i -e"s/^pass=.*/pass=$NEWPASS/" config.txt

sleep 0.5

#hash the password
torpass=$(tor --hash-password '$NEWPASS')

sleep 2

clear

#append hashed password to torrc file
printf "HashedControlPassword $torpass\nControlPort 9051\n" | sudo tee -a /etc/tor/torrc

echo "Your connection is now secured with a password"

sleep 2

clear

echo "Restarting TOR to apply changes"
# Restarting tor service if it is running
if  systemctl is-active --quiet tor; then
    sudo systemctl restart tor
else 
    echo "tor service is not running, please check and start it"
fi

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

while true; do
    read -p "Do you want to have shell persistancy y/n? " yn
    case $yn in
        [Yy]* ) 
        
        echo "Turning torsocks on permanently"
        sleep 2

        #Both medthod for Enabling/Disabling added
        # ->
        torsocks off
        source torsocks off

        sleep 2

        echo  "Modifying ~/.bashrc - Please Wait"
        echo ". torsocks on" >> ~/.bashrc

        sleep 2

        echo "Modifying ~/.zshrc - Please Wait"
        echo ". torsocks on" >> ~/.zshrc

        sleep 2

        echo "Restarting TOR - Please Wait"
        sudo systemctl restart tor

        sleep 2

        echo "Setting torsocks on - Please Wait"
        sleep 2

        #Both method for Enabling/Disabling added
        # ->
        torsocks on
        source torsocks on

        sleep 2

        clear

        break;;

        [Nn]* ) 
        clear            
        echo "You chose to set torsocks manually."
        sleep 1
        break ;;

        * ) echo "Please answer yes or no.";;
    esac
done

echo "--------------------------------------------------------------
Please use the following commands to activate/deactivate TOR:

$ source torsocks on
(( Tor mode activated )) 

$ source torsocks off
(( Tor mode deactivated ))
"
#Checking IP outide the tor network
echo "Please wait, checking your ip outside the TOR network"
wget -qO - https://api.ipify.org; echo
sleep 0.25

#Checking IP inside the tor network
echo "Please wait, checking your TOR ip."
torsocks wget -qO - https://api.ipify.org; echo 		
sleep 0.25
		
echo "             Thank you for using this script.                 "
echo "                    Have a great day!                         "
echo "--------------------------------------------------------------"
sleep 5

exit
