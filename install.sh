#!/bin/bash
set -e
set -o pipefail

# install.sh
# this installs(hopefully) everything for debian.  Credit to jessfraz for the base.

export DEBIAN_FRONTEND=noninteractive

# Choose a user account to use for this installation
get_user() {
	if [ -z "${TARGET_USER-}" ]; then
		mapfile -t options < <(find /home/* -maxdepth 0 -printf "%f\\n" -type d)
		# if there is only one option just use that user
		if [ "${#options[@]}" -eq "1" ]; then
			readonly TARGET_USER="${options[0]}"
			echo "Using user account: ${TARGET_USER}"
			return
		fi

		# iterate through the user options and print them
		PS3='Which user account should be used? '

		select opt in "${options[@]}"; do
			readonly TARGET_USER=$opt
			break
		done
	fi
}

check_is_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}


setup_sources_min() {
	apt update
	apt install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		dirmngr \
		lsb-release \
		wget \
		--no-install-recommends

	# hack for latest git (don't judge)
	cat <<-EOF > /etc/apt/sources.list.d/git-core.list
	deb http://ppa.launchpad.net/git-core/ppa/ubuntu xenial main
	deb-src http://ppa.launchpad.net/git-core/ppa/ubuntu xenial main
	EOF

	# neovim
	cat <<-EOF > /etc/apt/sources.list.d/neovim.list
	deb http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu xenial main
	deb-src http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu xenial main
	EOF

	# add the git-core ppa gpg key
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24

	# add the neovim ppa gpg key
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 9DBB0BE9366964F134855E2255F96FCF8231B6DD

	# turn off translations, speed up apt update
	mkdir -p /etc/apt/apt.conf.d
	echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations
}

# sets up apt sources
# assumes you are going to use debian buster
setup_sources() {
	setup_sources_min;

	cat <<-EOF > /etc/apt/sources.list
	deb http://ftp.debian.org/debian buster main contrib non-free
	deb-src http://ftp.debian.org/debian buster main contrib non-free

	deb http://ftp.debian.org/debian buster-updates main contrib non-free
	deb-src http://ftp.debian.org/debian buster-updates main contrib non-free

	deb http://security.debian.org/ buster/updates main contrib non-free
	deb-src http://security.debian.org/ buster/updates main contrib non-free

	#deb http://ftp.debian.org/debian jessie-backports main contrib non-free
	#deb-src http://ftp.debian.org/debian jessie-backports main contrib non-free

	deb http://ftp.debian.org/debian experimental main contrib non-free
	deb-src http://ftp.debian.org/debian experimental main contrib non-free

	deb http://dl.google.com/linux/chrome/deb stable main
	EOF
}

base_min() {
	apt update
	apt -y upgrade

	apt install -y \
		adduser \
		automake \
		bash-completion \
		bc \
		bzip2 \
		ca-certificates \
		coreutils \
		curl \
		dnsutils \
		file \
		findutils \
		gcc \
		git \
		gnupg \
		gnupg2 \
		gnupg-agent \
		grep \
		gzip \
		hostname \
		indent \
		iptables \
		jq \
		less \
		libc6-dev \
		libimobiledevice6 \
		locales \
		lsof \
		make \
		mount \
		net-tools \
		neovim \
		pinentry-curses \
		scdaemon \
		ssh \
		strace \
		sudo \
		tar \
		tree \
		tzdata \
		ufw \
		usbmuxd \
		unzip \
		xclip \
		xcompmgr \
		xz-utils \
		zip \
		--no-install-recommends

	apt autoremove
	apt autoclean
	apt clean
}

# installs base packages
# the utter bare minimal shit
base() {
	base_min;

	apt update
	apt -y upgrade

	apt install -y \
		clamav \
		network-manager \
		openvpn \
		python3 \
		python3-pip \
		python3-setuptools
		network-manager \
		network-manager-openvpn \
		--no-install-recommends

	setup_sudo

	apt autoremove
	apt autoclean
	apt clean
}

# setup sudo for a user
# because fuck typing that shit all the time
# just have a decent password
# and lock your computer when you aren't using it
# if they have your password they can sudo anyways
# so its pointless
# i know what the fuck im doing ;)
setup_sudo() {
	# add user to sudoers
	adduser "$TARGET_USER" sudo

	# add user to systemd groups
	# then you wont need sudo to view logs and shit
	gpasswd -a "$TARGET_USER" systemd-journal
	gpasswd -a "$TARGET_USER" systemd-network

	{ \
		echo -e "${TARGET_USER} ALL=(ALL) NOPASSWD:ALL"; \
		echo -e "${TARGET_USER} ALL=NOPASSWD: /sbin/ifconfig, /sbin/ifup, /sbin/ifdown, /sbin/ifquery"; \
	} >> /etc/sudoers

}

# install stuff for i3 window manager
install_wmapps() {
	local pkgs=( feh i3 i3lock scrot sflock conky-all compton rofi ranger htop firefox )

	apt install -y "${pkgs[@]}" --no-install-recommends
}

get_dotfiles() {
	(
	cd "$HOME"

	git clone https://github.com/j3bj3nky/dotfiles.git "{$HOME}/dotfiles"
	)

	install_vim;
}


install_vim() {
	(
	cd "$HOME"
	mkdir -p ~/.local/share/nvim/plugged
	mkdir -p ~/.config/nvim
	cd "{$HOME}/config/nvim"
	cp "{$HOME}/dotfiles/vim/init.vim" .
	cp -r "{$HOME}/dotfiles/vim/ftplugin" .
	)
}


main() {
	check_is_sudo
	get_user
	setup_sources
	base
	get_dotfiles
	install_wmapps
}
main "$@"

