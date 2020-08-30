#!/usr/bin/env bash

set -ex

BREW=/usr/local/bin/brew
PIP=/usr/local/opt/python/libexec/bin/pip

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
defaults write NSGlobalDomain KeyRepeat -float .5
defaults write NSGlobalDomain InitialKeyRepeat -int 25

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

# cmd + h/j switch tabs
defaults write NSGlobalDomain NSUserKeyEquivalents '{"Select Previous Tab"="@h"; "Select Next Tab"="@l"; "Next Chat"="@l"; "Show Next Tab"="@l"; "Show Previous Tab"="@h"; "Previous Chat"="@h";}'

# disable mission control's control + arrow shortcuts
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 "{enabled = 0; value = { parameters = (65535, 18, 262144); type = 'standard'; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{enabled = 0; value = { parameters = (65535, 123, 262144); type = 'standard'; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 "{enabled = 0; value = { parameters = (65535, 123, 393216); type = 'standard'; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{enabled = 0; value = { parameters = (65535, 124, 262144); type = 'standard'; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 "{enabled = 0; value = { parameters = (65535, 124, 393216); type = 'standard'; }; }"
defaults import com.apple.symbolichotkeys "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

# Remap capslock to control
# https://stackoverflow.com/questions/127591/using-caps-lock-as-esc-in-mac-os-x
# https://apple.stackexchange.com/questions/283252/how-do-i-remap-a-key-in-macos-sierra-e-g-right-alt-to-right-control/349440#349440
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'
sudo defaults write com.apple.loginwindow LoginHook ~/dotfiles/key-remap.sh


if [ ! "$(which gcc)" ] ; then
    echo "Please download XCode here: https://developer.apple.com/downloads/index.action"
    exit 1
fi

if [ ! -x $BREW ] ; then
    echo 'installing homebrew'
    echo export PATH="/usr/local/bin:\$PATH" >> ~/.bash_profile
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo 'updating homebrew'
$BREW update

if [ ! "$(which git)" ] ; then
    echo 'installing git'
    $BREW install git
fi

$BREW doctor
if [ $? -ne 0 ] ; then
    echo 'bad doctor'
    exit 1
fi

$BREW install ack
$BREW install ag
$BREW install cmake
$BREW install colordiff
$BREW install ctags
$BREW install curl
$BREW install fasd
$BREW install fzf
$BREW install geoip
$BREW install go
$BREW install htop-osx
$BREW install jq
$BREW install libksba
$BREW install libmemcached
$BREW install libxml2
$BREW install libxslt
$BREW install libyaml
$BREW install lzo
$BREW install memcached
$BREW install mongodb
$BREW install moreutils
$BREW install mysql
$BREW install nginx
$BREW install nvim
$BREW install python
$BREW install readline
$BREW install redis
$BREW install rg
$BREW install sphinx
$BREW install sqlite
$BREW install task
$BREW install thefuck
$BREW install v8
$BREW install vim
$BREW install wget
$BREW install xz
$BREW cask install iterm2
$BREW cask install rescuetime
$BREW cleanup

defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"; killall Dock


if [ ! "$(which ipython)" ] ; then
    echo 'installing ipython'
    $PIP install ipython
fi

if [ ! "$(which aws)" ] ; then
    echo 'installing awscli'
    $PIP install awscli
    complete -C aws_completer aws
fi

$PIP install --user neovim flake8 pylint pep8 virtualenv


./install.sh

echo
echo "now log out"
