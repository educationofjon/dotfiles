#!/bin/sh

print()
{
	echo $1
}

print_install()
{
	print "Installing $1"
}

install_tools()
{
	pacman -S fish mosh fzf weechat wget curl tree git tmux vim mc tig

	pacman -S iterm2 emacs firefox chromium caffeine flux qbittorrent the-unarchiver skype vlc spotify appcleaner disk-inventory-x dash
}

install_dev_tools()
{
	pacman -S nodejs npm jq icdiff cloc hub rebar python python2 ack tree leiningen ctags
}

install_vim_lunfardo()
{
	if [ ! -d "~/.vim/" ]
	then
		curl -L https://raw.githubusercontent.com/unbalancedparentheses/vim-lunfardo/master/bootstrap.sh | bash
	fi
}

install_emacs_lunfardo()
{
	if [ ! -d "~/.emacs.d/" ]
	then
		git clone --depth=1 https://github.com/unbalancedparentheses/emacs-lunfardo.git ~/.emacs.d/
	fi
}

install_tools
install_dev_tools

install_vim_lunfardo
install_emacs_lunfardo

open https://gitlab.com/rojii0xff/backup
