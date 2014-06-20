#!/usr/bin/env bash

BREW=/usr/local/bin/brew
PIP=/usr/local/bin/pip

# don't write DS_Store on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# default list view in finder
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# reverse scroll direction
defaults write ~/Library/Preferences/.GlobalPreferences com.apple.swipescrolldirection -bool false

# turn on dock hiding
defaults write com.apple.dock autohide -bool true

# 2d dock
defaults write com.apple.dock no-glass -bool true

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
defaults write NSGlobalDomain KeyRepeat -int .5

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

# Remap capslock to control (seriously)
keyboard_ids=$(ioreg -n IOHIDKeyboard -r | grep -E 'VendorID"|ProductID' | awk '{ print $4 }' | paste -s -d'-\n' -) && echo $keyboard_ids | xargs -I{} defaults -currentHost write -g "com.apple.keyboard.modifiermapping.{}-0" -array "<dict><key>HIDKeyboardModifierMappingDst</key><integer>10</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>"


if [ ! `which gcc` ] ; then
    echo "Please download XCode here:"
    echo "\thttps://developer.apple.com/downloads/index.action"
    exit 1
fi

if [ ! -x $BREW ] ; then
    echo 'installing homebrew'
    echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
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
$BREW install libyaml
$BREW install fuse4x
$BREW install htop-osx
$BREW install vim

if [ ! `which ipython` ] ; then
    echo 'installing ipython'
    $PIP install ipython
fi

if [ ! `which yas3fs` ] ; then
    echo 'installing yas3fs'
    # https://github.com/danilop/yas3fs/issues/26
    $PIP install boto==2.27.0
    $PIP install yas3fs
fi

if [ ! `which aws` ] ; then
    echo 'installing awscli'
    $PIP install awscli
    complete -C aws_completer aws
fi

if [ ! `which rvm` ] ; then
    echo 'installing rvm'
    curl -sSL https://get.rvm.io | bash -s stable --ruby
    # workaround for https://github.com/Homebrew/homebrew/issues/23938
    source /Users/$USER/.rvm/scripts/rvm
    /Users/$USER/.rvm/bin/rvm system
fi

# homebrew's bash completions
ln -s "/usr/local/Library/Contributions/brew_bash_completion.sh" "/usr/local/etc/bash_completion.d"

echo
echo "Remember to configure ~/.aws/config!"
echo
echo "Download DejaVu here: http://dejavu-fonts.org/wiki/Download"
echo
echo "Download iTerm here: http://www.iterm2.com/#/section/downloads"
echo
echo "Download Adium here: https://adium.im"
echo
echo "Download Rescue Time here: rescuetime.com"
echo
