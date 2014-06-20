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

echo "installing dotfile(s)..."
for i in _$1*
do
	if [ $i == '_Preferences' -a -d "${HOME}/Library" ]; then
		for pref in _Preferences/*
		do
			cp $pref "${HOME}/Library/${pref/_/}"
		done
	else
		link_file $i
	fi
done

echo "updating submodules..."
git submodule update --init j
git submodule --quiet sync
git submodule --quiet init
git submodule --quiet foreach "git pull -q origin master; git reset --hard HEAD"
git submodule update --merge --recursive

