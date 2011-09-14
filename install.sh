#!/usr/bin/env bash
function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

	# backup if the file is already there (and not a symlink)
    if [ -e "${target}" -a ! -L "${target}" ]; then
		echo "    backing up $target"
        mv $target $target.bak
    fi

	echo "    installing $target"
    ln -sfn ${source} ${target}
}

echo "installing dotfile(s)..."
for i in _$1*
do
	link_file $i
done

echo "updating submodules..."
git submodule --quiet sync
git submodule --quiet init
git submodule --quiet foreach git pull -q origin master
git submodule update --merge --recursive

