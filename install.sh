#!/usr/bin/env zsh

function link_file {
	source="${PWD}/$1"
	if [ "$2" ]; then
		target=$2
	else
		target="${HOME}/${1/_/.}"
	fi

	# backup if the file is already there (and not a symlink)
	if [ -e "${target}" -a ! -L "${target}" ]; then
		echo "	backing up $target"
		mv "$target" "$target.bak"
	fi

	echo "	installing $target"
	ln -sfn "$source" "$target"
}

if [ ! "$(which brew)" ]; then # TODO(Darwin)
  echo 'installing homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -d $HOME/src ]; then
  echo 'creating ~/src'
  mkdir $HOME/src
fi

pushd $HOME/src

if [ ! $HOME/.ssh/known_hosts ]; then
    mkdir -p $HOME/.ssh
    ssh-keyscan github.com > $HOME/.ssh/known_hosts
fi

if [ ! -d $HOME/src/dotfiles ]; then
  echo 'cloning dotfiles into ~/src'
  git clone https://github.com/blampe/dotfiles.git
  cd dotfiles # TODO(remove)
  git checkout origin/refactor # TODO(remove)
fi

pushd $HOME/src/dotfiles

for tap in $(cat brew/taps); do
  brew tap $tap
done

brew fetch --casks $(cat brew/casks | tr '\n' ' ') >/dev/null &
brew fetch --deps $(cat brew/formulae | tr '\n' ' ') >/dev/null &

brew install --casks $(cat brew/casks | tr '\n' ' ')
brew install $(cat brew/formulae | tr '\n' ' ')

brew cleanup

echo "installing dotfiles..."
for i in _$1*
do
    link_file "$i"
done

git submodule update --init

echo "installing zsh themes and plugins..."
link_file "zsh/plugins" "${HOME}/.oh-my-zsh/custom/plugins"
link_file "zsh/themes" "${HOME}/.oh-my-zsh/custom/themes"

echo "installing vim plugins..."
vim +PlugInstall +qall

if [[ `uname` =~ "Darwin" ]]; then
    echo "installing preferences..."
    for i in Library/Preferences/*
    do
        link_file "$i" "${HOME}/$i"
    done

    if [ -f ~/.macos ]; then
        . ~/.macos
    fi
fi
