#!/usr/bin/env bash
function link_file {
	source="${PWD}/$1"
	if [ $2 ]; then
		target=$2
	else
		target="${HOME}/${1/_/.}"
	fi

	# backup if the file is already there (and not a symlink)
	if [ -e "${target}" -a ! -L "${target}" ]; then
		echo "	backing up $target"
		mv $target $target.bak
	fi

	echo "	installing $target"
	ln -sfn ${source} ${target}
}

echo "installing dotfiles..."
for i in _$1*
do
    link_file $i
done

echo "installing fonts..."
for i in Library/Fonts/*
do
    cp $i "${HOME}/$i"
done

echo "installing preferences..."
for i in Library/Preferences/*
do
    cp $i "${HOME}/$i"
done

if [ ! -d ~/.aws ]; then
    mkdir ~/.aws
    mkdir ~/s3
    cp ~/dotfiles/aws/config ~/.aws/config
    cp ~/dotfiles/aws/passwd-s3fs ~/.aws/passwd-s3fs
    chmod 600 ~/.aws/*
    echo "remember to update AWS credentials in ~/.aws..."
fi

echo "updating submodules..."
git submodule update --init j
git submodule --quiet sync
git submodule --quiet init
git submodule --quiet foreach "git pull -q origin master; git reset --hard HEAD"
git submodule update --merge --recursive

