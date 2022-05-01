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
        echo "    backing up $target"
        mv "$target" "$target.bak"
    fi

    echo "    installing $target"
    mkdir -p "$(dirname $target)"
    ln -sfn "$source" "$target"
}

echo "installing dotfiles..."
for i in _$1*
do
    link_file "$i"
done

git submodule update --init

echo "installing vim plugins..."
vim +PlugInstall +GoInstallBinaries +qall

if [[ `uname` =~ "Darwin" ]]; then
    echo "installing preferences..."
    find Library -not -type d | while read i;
    do
        link_file "$i" "${HOME}/$i"
    done

    echo "installing fonts..."
    brew tap homebrew/cask-fonts
    brew reinstall --cask font-fira-code-nerd-font
    brew reinstall --cask font-dejavu-sans-mono-nerd-font
    brew reinstall --cask font-meslo-lg-nerd-font
fi

if [[ -x /Applications/VSCodium.app/Contents/Resources/app/bin/codium ]]; then
    echo "installing vscode extensions"
    for ext in $(cat ~/.vscode/extensions.txt); do
        (/Applications/VSCodium.app/Contents/Resources/app/bin/codium --install-extension $ext || true) >/dev/null &
    done
    wait
    /Applications/VSCodium.app/Contents/Resources/app/bin/codium --list-extensions | sort > ~/.vscode/extensions.txt
fi
