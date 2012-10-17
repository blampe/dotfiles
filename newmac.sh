#!/usr/bin/env bash
#set -x

BREW=/usr/local/bin/brew

if [ ! `which gcc` ] ; then
	echo "Please download XCode here:"
	echo "\thttps://developer.apple.com/downloads/index.action"
	exit 1
fi

if [ ! -d /usr/local/Cellar ] ; then
	echo 'creating /usr/local/Cellar'
	mkdir -p /usr/local/Cellar
	sudo chown `whoami` /usr/local
	sudo chown `whoami` /usr/local/etc
	sudo chown `whoami` /usr/local/lib
	sudo chown `whoami` /usr/local/share/doc
	sudo chown `whoami` /usr/local/share/man/*
	sudo chown `whoami` /usr/local/Cellar
fi

if [ ! -x $BREW ] ; then
	echo 'installing homebrew'
	/usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
	echo 'changing xcode path to /'
fi

echo 'updating homebrew'
$BREW update

if [ ! -x /usr/local/bin/git ] ; then
	echo 'installing git'
	$BREW install git
fi

$BREW doctor
if [ $? -ne 0 ] ; then
	echo 'bad doctor'
	exit 1
fi

if [ ! -x /usr/local/bin/hg ] ; then
	echo 'installing mercurial'
	$BREW install mercurial
fi

if [ ! -d /usr/local/Cellar/autoconf ] ; then
	echo 'installing autoconf'
	$BREW install autoconf
fi

if [ ! -d /usr/local/Cellar/automake ] ; then
	echo 'installing automake'
	$BREW install automake
fi

if [ ! -x ~/.rvm/bin/rvm ] ; then
	echo 'installing rvm'
	bash -s master < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
	echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
	echo '[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion' >> ~/.bash_profile
	echo 'source ~/.profile' >> ~/.bash_profile
fi

if [ ! `which ipython` ] ; then
	echo 'installing ipython'
	sudo easy_install ipython
fi

$BREW install libksba
$BREW install ack
$BREW install wget
$BREW install curl
$BREW install redis
$BREW install memcached
$BREW install libmemcached
$BREW install colordiff
$BREW install nginx
$BREW install sqlite
$BREW install libxml2
$BREW install libxslt
$BREW install v8
$BREW install sphinx
$BREW install xz
$BREW install geoip
$BREW install lzo
$BREW install mysql
$BREW install mongodb
$BREW install readline
$BREW install bash-completion
$BREW install ctags
# breaks some things?
#$BREW link readline

# homebrew's bash completions
ln -s "/usr/local/Library/Contributions/brew_bash_completion.sh" "/usr/local/etc/bash_completion.d"

$BREW install https://raw.github.com/AndrewVos/homebrew-alt/master/duplicates/vim.rb

# Source RVM as a function into local environment.
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

# TODO: short-circuit
$HOME/.rvm/bin/rvm get head
$HOME/.rvm/bin/rvm install 1.9.3-p125 --enable-shared --with-readline-dir=/usr/local
$HOME/.rvm/bin/rvm gemset create
$HOME/.rvm/rubies/ruby-1.9.3-p125/bin/gem install rails bundler unicorn rspec pg
$HOME/.rvm/bin/rvm pkg install readline
$HOME/.rvm/bin/rvm --default use 1.9.3-p125

echo "remember to install DejaVu here:"
echo "\thttp://dejavu-fonts.org/wiki/Download"
