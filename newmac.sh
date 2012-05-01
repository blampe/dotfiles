#!/usr/bin/env bash

if [ ! -d /usr/local/Cellar ] ; then
	echo 'creating /usr/local/Cellar'
	mkdir -p /usr/local/Cellar
	chown `whoami` /usr/local/Cellar
fi

if [ ! -x /usr/local/bin/brew ] ; then
	echo 'installing homebrew'
	/usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
fi

echo 'updating homebrew'
/usr/local/bin/brew update

if [ ! -x /usr/local/bin/git ] ; then
	echo 'installing git'
	/usr/local/bin/brew install git
fi

/usr/local/bin/brew doctor
if [ $? -ne 0 ] ; then
	echo 'bad doctor'
	exit 1
fi

if [ ! -x /usr/local/bin/hg ] ; then
	echo 'installing mercurial'
	/usr/local/bin/brew install mercurial
fi

if [ ! -d /usr/local/Cellar/autoconf ] ; then
	echo 'installing autoconf'
	/usr/local/bin/brew install autoconf
fi

if [ ! -d /usr/local/Cellar/automake ] ; then
	echo 'installing automake'
	/usr/local/bin/brew install automake
fi

if [ ! -x ~/.rvm/bin/rvm ] ; then
	echo 'installing rvm'
	bash -s master < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
	echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
	echo '[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion' >> ~/.bash_profile
	echo 'source ~/.profile' >> ~/.bash_profile
fi

/usr/local/bin/brew install libksba ack wget curl redis memcached libmemcached colordiff nginx sqlite libxml2 libxslt v8 sphinx xz geoip lzo mysql mongodb readline bash-completion ctags
# breaks some things?
#/usr/local/bin/brew link readline

# homebrew's bash completions
ln -s "/usr/local/Library/Contributions/brew_bash_completion.sh" "/usr/local/etc/bash_completion.d"

/usr/local/bin/brew install https://raw.github.com/AndrewVos/homebrew-alt/master/duplicates/vim.rb

# Source RVM as a function into local environment.
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

# TODO: short-circuit
$HOME/.rvm/bin/rvm get head
$HOME/.rvm/bin/rvm install 1.9.3-p125 --enable-shared --with-readline-dir=/usr/local
$home/.rvm/bin/rvm gemset create
$HOME/.rvm/rubies/ruby-1.9.3-p125/bin/gem install rails bundler unicorn pg rspec
$HOME/.rvm/bin/rvm pkg install readline
$HOME/.rvm/bin/rvm --default use 1.9.3-p125

