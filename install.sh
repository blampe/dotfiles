#!/usr/bin/env bash
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

echo "installing fonts..."
for i in Library/Fonts/*
do
    cp "$i" "${HOME}/$i"
done

echo "installing zsh themes and plugins..."
link_file "zsh/plugins" "${HOME}/.oh-my-zsh/custom/plugins"
link_file "zsh/themes" "${HOME}/.oh-my-zsh/custom/themes"

echo "installing preferences..."
for i in Library/Preferences/*
do
    cp "$i" "${HOME}/$i"
done

vim +PlugInstall +qall
