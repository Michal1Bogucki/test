#!/bin/bash
##
echo $'Podaj nazwę urzytkownika:\n'
read USER_NAME
echo $'Ponownie podaj nazwę urzytkownika:\n'
read USER_NAME_CONFIRM

if [ "$USER_NAME" = "$USER_NAME_CONFIRM" ]; then
deluser $USER_NAME
rm -R /home/$USER_NAME

echo $'Podaj hasło:\n'
read -s PASSWORD

echo $'Ponownie podaj hasło:'
read -s PASSWORD_CONFIRM


	if [ "$PASSWORD" == "$PASSWORD_CONFIRM" ]; then
	p="sudo -u $USER_NAME"
	
	useradd -m -p $(openssl passwd -1 $PASSWORD) $USER_NAME
	usermod -aG root $USER_NAME
	
	$p ssh-keygen -t rsa -b 4096 -f /home/$USER_NAME/.ssh/${USER_NAME}_id_rsa -P ""
	$p mkdir /home/$USER_NAME/.ssh	

	$p  mkdir /home/$USER_NAME/export
	$p puttygen /home/$USER_NAME/.ssh/${USER_NAME}_id_rsa -o /home/$USER_NAME/export/${USER_NAME}_id_rsa.ppk

	$p cat /home/$USER_NAME/.ssh/${USER_NAME}_id_rsa.pub >> /home/$USER_NAME/.ssh/authorized_keys
	#mv ./${USER_NAME}_id_rsa.ppk /home/$USER_NAME/export/
	else
	echo "Hasła niezgadzają się"
	fi

else
echo "Nazwa urzytkownika niezgadza się"
fi


