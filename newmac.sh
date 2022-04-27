#!/usr/bin/env bash

set -ex

BREW=/usr/local/bin/brew
PIP=/usr/local/opt/python3/libexec/bin/pip

if [ ! "$(which gcc)" ]; then
  echo "Please download XCode here: https://developer.apple.com/downloads/index.action"
  exit 1
fi

if [ ! -x $BREW ]; then # TODO(Darwin)
  echo 'installing homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo 'updating homebrew'
$BREW update

if [ ! "$(which git)" ]; then
  echo 'installing git'
  $BREW install git
  $BREW tap microsoft/git
  $BREW install --cask git-credential-manager-core
fi

$BREW doctor
if [ $? -ne 0 ]; then
  echo 'bad doctor'
  exit 1
fi

$BREW install ack || true
$BREW install ag || true
$BREW install cmake || true
$BREW install colordiff || true
$BREW install ctags || true
$BREW install curl || true
$BREW install direnv || true
$BREW install fasd || true
$BREW install fzf || true
$BREW install geoip || true
$BREW install go || true
$BREW install htop-osx || true
$BREW install jq || true
$BREW install kubectl || true
$BREW install libksba || true
$BREW install libmemcached || true
$BREW install libxml2 || true
$BREW install libxslt || true
$BREW install libyaml || true
$BREW install lzo || true
$BREW install memcached || true
$BREW install moreutils || true
$BREW install mysql || true
$BREW install nginx || true
$BREW install node || true
$BREW install nvim || true
$BREW install postgres || true
$BREW install python || true
$BREW install rbenv || true
$BREW install readline || true
$BREW install redis || true
$BREW install rg || true
$BREW install shellcheck shfmt || true
$BREW install sphinx || true
$BREW install sqlite || true
$BREW install task || true
$BREW install thefuck || true
$BREW install tree || true
$BREW install v8 || true
$BREW install vim || true
$BREW install watchman || true
$BREW install wget || true
$BREW install xz || true
$BREW install yarn || true
$BREW install yq || true
$BREW install --cask iterm2 || true
$BREW install --cask karabiner-elements || true
$BREW install --cask hammerspoon || true
$BREW install --cask postman || true
$BREW install --cask rescuetime || true
$BREW tap homebrew/services || true
$BREW cleanup

defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
killall Dock

if [ ! "$(which ipython)" ]; then
  echo 'installing ipython'
  $PIP install ipython
fi

if [ ! "$(which aws)" ]; then
  echo 'installing awscli'
  $PIP install awscli
  complete -C aws_completer aws
fi

if [ ! "$(which gcloud)" ]; then
  echo 'installing gcloud'
  $BREW install --cask google-cloud-sdk
fi

$PIP install --user neovim flake8 pylint pep8

if [ ! -d "$HOME/src/gcalcli" ]; then
  echo 'installing gcalcli'
  mkdir -p ~/src
  git clone https://github.com/insanum/gcalcli.git ~/src/gcalcli
  pushd ~/src/gcalcli
  python3 -m venv env
  . env/bin/activate
  python3 setup.py install
  deactivate
  popd
fi

./install.sh

echo
echo "now log out"
