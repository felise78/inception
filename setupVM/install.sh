#!/usr/bin/env -S zsh --no-rcs --no-globalrcs --errexit



# -- C O L O R S --------------------------------------------------------------

# success color
declare -r color='\x1b[32m'
# success color
declare -r success='\x1b[33m'
# error color
declare -r error='\x1b[31m'
# reset color
declare -r reset='\x1b[0m'

function ___success() {
	echo '\n---' $success'success:'$reset $1'\n'
}

# -- R O O T ------------------------------------------------------------------


echo '\n'$color'R O O T  C H E C K'$reset

# exit if not root
if [ $(id -u) -ne 0 ]; then
	echo 'please run as root 😢'
	exit 1
else
	___success 'running as root 👾'
fi


# -- U P D A T E  &  U P G R A D E --------------------------------------------

echo '\n'$color'U P D A T E  &  U P G R A D E'$reset'\n'

# update apt-get
if ! apt-get 'update'; then
	echo $error'failed'$reset 'to update apt-get 😢'
	exit 1
fi

# upgrade apt-get
if ! apt-get 'upgrade' -y; then
	echo $error'failed'$reset 'to upgrade apt-get 😢'
	exit 1
fi

___success 'updated & upgraded 👍'




# -- P A C K A G E S ----------------------------------------------------------

echo '\n'$color'P A C K A G E S'$reset'\n'

# packages to install
declare -r packages=(
	'zsh'
	'git'
	'curl'
	'vim'
	'sudo'
	'wget'
	'hostsed'
	'ca-certificates'
	'gnupg2'
	'make'
	'ssh'
	'openssh-server'
	'apt-transport-https'
	'software-properties-common'
)



# install package
function ___install_package() {

	# return if no package is given
	[[ -z $1 ]] && return

	# check if command exists
	if command -v $1 &> /dev/null; then
		# return
		echo 'already installed 😄 ->' $color$1$reset

	# check if package is installed
	elif dpkg -l $1 &> /dev/null; then
		# return
		echo 'already installed 😄 ->' $color$1$reset

	else

		# install package
		if ! apt-get 'install' -y $1; then
			echo 'failed to install 😢 ->' $error$1$reset
			exit 1
		fi

		# success
		echo 'installed 😄 ->' $color$1$reset
	fi
}


# loop over packages
for package in $packages; do
	___install_package $package
done

___success 'all packages installed 👍'


# -- D O C K E R  S E T U P ---------------------------------------------------

echo '\n'$color'D O C K E R  S E T U P'$reset'\n'


# install keyring
if ! install -m 0755 -d '/etc/apt/keyrings'; then
	echo 'failed to create keyrings directory 😢'
	exit 1
else
	echo 'created keyrings directory 📁'
fi

# download docker key
if ! curl -fsSL 'https://download.docker.com/linux/debian/gpg' -o '/etc/apt/keyrings/docker.asc'; then
	echo 'failed to download docker key 😢'
	exit 1
else
	echo 'downloaded docker key 🔑'
fi

# change permissions of docker key
if ! chmod 'a+r' '/etc/apt/keyrings/docker.asc'; then
	echo 'failed to change permissions of docker key 😢'
	exit 1
else
	echo 'changed permissions of docker key 🔑'
fi

# docker list
declare -r docker_list='/etc/apt/sources.list.d/docker.list'

# write configuration to docker list
echo -n 'deb [arch=' > $docker_list
echo -n $(dpkg --print-architecture)' ' >> $docker_list
echo -n 'signed-by=/etc/apt/keyrings/docker.asc] ' >> $docker_list
echo -n 'https://download.docker.com/linux/debian ' >> $docker_list
echo -n $(. /etc/os-release && echo $VERSION_CODENAME)' ' >> $docker_list
echo -n 'stable' >> $docker_list


___success 'docker setup complete 👍'


# -- D O C K E R  I N S T A L L -----------------------------------------------

echo '\n'$color'D O C K E R  I N S T A L L'$reset'\n'

# update apt-get
if ! apt-get 'update'; then
	echo 'failed to update apt-get 😢'
	exit 1
fi

# docker packages
declare -r docker_packages=(
	'docker-ce'
	'docker-ce-cli'
	'containerd.io'
	'docker-buildx-plugin'
	'docker-compose-plugin'
	'docker-compose'
)

# loop over docker packages
for package in $docker_packages; do
	___install_package $package
done

echo

# check docker version and docker-compose version
##if ! docker --version; then
#	echo 'failed to check docker version 😢'
#	exit 1
#fi
#
#if ! docker-compose --version; then
#	echo 'failed to check docker-compose version 😢'
#	exit 1
#fi

echo

if ! systemctl status docker '--no-pager' -n 0; then
	echo 'failed to check docker status 😢'
	exit 1
fi


___success 'docker installed 👍'



# -- C L E A N U P ------------------------------------------------------------

echo '\n'$color'C L E A N U P'$reset'\n'

# remove packages
if ! apt-get 'autoremove' --purge -y; then
	echo 'failed to remove packages 😢'
	exit 1
else
	echo 'removed packages 😄'
fi

# clean apt-get
if ! apt-get 'clean'; then
	echo 'failed to clean apt-get 😢'
	exit 1
else
	echo 'cleaned apt-get 😄'
fi

# autoclean apt-get
if ! apt-get 'autoclean'; then
	echo 'failed to autoclean apt-get 😢'
	exit 1
else
	echo 'autocleaned apt-get 😄'
fi

___success 'cleaned up 👍'



# -- S H E L L ----------------------------------------------------------------

if ! chsh '-s' $(which zsh); then
	echo 'failed to change shell 😢'
	exit 1
else
	echo 'changed shell 😄'
fi


# -- G I T --------------------------------------------------------------------

#git config --global user.email "felise78@gmail.com"
#git config --global user.name "felise"

