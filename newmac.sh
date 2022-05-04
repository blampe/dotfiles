#!/usr/bin/env bash

set -ex

BREW=/usr/local/bin/brew
PIP=/usr/local/opt/python3/libexec/bin/pip

# don't write DS_Store on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# default list view in finder
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# turn on dock hiding
defaults write com.apple.dock autohide -bool true

# open new windows in my home dir
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# show the ~/Library folder
chflags nohidden ~/Library

# enable text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true

# use the Pro theme by default in terminal
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"
defaults import com.apple.Terminal "$HOME/Library/Preferences/com.apple.Terminal.plist"

# expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# use AirDrop over every interface
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# enable text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -boolean true

# show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Safari - Always Open in Tabs
defaults write com.apple.Safari TabCreationPolicy -int 2

# Safari - Show Status Bar
defaults write com.apple.Safari ShowStatusBar -bool true

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Disable the iTunes arrow links
defaults write com.apple.iTunes show-store-arrow-links -bool false

# Disable dashboard
defaults write com.apple.dashboard mcx-disabled -boolean YES

# disable mission control's control + arrow shortcuts
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 "{enabled = 0; value = { parameters = (65535, 18, 262144); type = 'standard'; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{enabled = 0; value = { parameters = (65535, 123, 262144); type = 'standard'; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 "{enabled = 0; value = { parameters = (65535, 123, 393216); type = 'standard'; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{enabled = 0; value = { parameters = (65535, 124, 262144); type = 'standard'; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 "{enabled = 0; value = { parameters = (65535, 124, 393216); type = 'standard'; }; }"
defaults import com.apple.symbolichotkeys "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

if [ ! "$(which gcc)" ]; then
  echo "Please download XCode here: https://developer.apple.com/downloads/index.action"
  exit 1
fi

if [ ! -x $BREW ]; then
  echo 'installing homebrew'
  echo export PATH="/usr/local/bin:\$PATH" >> ~/.bash_profile
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
$BREW install asdf || true
$BREW install cmake || true
$BREW install colordiff || true
$BREW install ctags || true
$BREW install curl || true
$BREW install direnv || true
$BREW install fasd || true
$BREW install fzf || true
$BREW install geoip || true
$BREW install go || true
$BREW install gofumpt || true
$BREW install htop-osx || true
$BREW install jq || true
$BREW install kubectl || true
$BREW install latexindent || true
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
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport prefs joinMode=Strongest

# Reduce motion
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Instance switching between spaces
defaults write com.apple.dock workspaces-edge-delay -float 0.1

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
