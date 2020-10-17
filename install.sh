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

    echo "installing fonts..."
    brew tap homebrew/cask-fonts
    brew cask upgrade font-fira-code-nerd-font
    brew cask upgrade font-dejavu-sans-mono-nerd-font
fi
