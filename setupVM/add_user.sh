#!/usr/bin/env -S zsh --no-rcs --no-globalrcs --errexit


## username
declare -r username='hemottu'
#
## password
declare -r password='user'
#
#
## check first argument is 'del'
#if [[ $1 == 'del' ]]; then
#
#	# check if user exists
#	if ! id -u $username &> /dev/null; then
#		echo 'user:' $username 'does not exist 😢'
#		exit 1
#	fi
#
#	# remove user
#	if ! deluser --remove-home $username; then
#		echo 'failed to remove user:' $username '😢'
#		exit 1
#	fi
#
#	# success
#	echo 'user:' $username 'removed 😄'
#	exit 0
#fi
#
#
#

## check if user exists
if id -u $username &> /dev/null; then
	echo 'user:' $username 'already exists 😄'
	exit 0
fi

# check if sudo exists
if ! command -v 'sudo' &> /dev/null; then
	echo 'sudo is required 😢'
	exit 1
fi

# add user arguments
declare -r args=(
	'--verbose'
	'--disabled-password'
	'--gecos' ',,,,'
	'--shell' $(which 'zsh')
	$username
)

# add user
if ! adduser $args; then
	echo 'failed to add user:' $username '😢'
	exit 1
fi

# set user password
if ! echo $username:$password | chpasswd; then
	echo 'failed to set user password 😢'
	exit 1
fi

# add user to sudo group
if ! usermod -aG 'sudo' $username; then
	echo 'failed to add user to sudo group 😢'
	exit 1
fi

# success
echo 'user added 😄'



# at the end to run docker from your user you need to add it to the docker group:
exit
# gpasswd -a $USER docker
#newgrp docker



#for the ssh you can edit the /etc/ssh/sshd_config file and change the port to 4242
#find the line with Port 22 and change it to Port 4242
#sudo service ssh restart

function ___ssh_config() {

	local -r file='/etc/ssh/sshd_config'

	# check if file exists
	touch $file

	# find the line with Port 22
	if ! grep -q 'Port 22' $file; then
		echo 'Port 22 not found 😢'
		exit 1
	fi
}

___ssh_config



# vscode: install the extension 'Remote - SSH: Editing Configuration Files'
# click the little icon on the bottom left
# click on connect current window to host if you want the same window
# choose + Add New SSH Host...
# write your username and localhost followed by the port ex:
# hemottu@localhost -p 4242
# click continue
# go for the first config file
# you can see that it's successfully connected when you see the pop up on the bottom right corner of the screen
# write the password of the user and you will be connected to the vm
# once the SSH:localhost appear on the bottom left corner of the screen you can just navigate to the folder you want to work on same as you do with your own computer


#to be able to access your website via username.42.fr you need to edit the /etc/hosts file and add the following line:
#vim /etc/hosts
#add new line under your host name
#127.0.0.1 username.42.fr


# get hostname
#declare -r host=$(hostname)
```

