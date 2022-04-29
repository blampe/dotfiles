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
  echo 'installing homebrew (requires sudo)'
  /usr/bin/sudo -v
  /bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -d $HOME/src ]; then
  echo 'creating ~/src'
  mkdir $HOME/src
fi

pushd $HOME/src

if [ ! $HOME/.ssh ]; then
    echo "creating an SSH key..."
    ssh-keygen -t rsa
    echo "paste this into https://github.com/account/ssh and press [Enter] when done..."
    read -p ""
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

FORMULAE=($(cat brew/formulae | tr '\n' ' '))
CURL=(curl -k -s --retry 3 --disable --cookie /dev/null --globoff --header 'Authorization: Bearer QQ==' --header 'Accept: application/vnd.oci.image.index.v1+json' --location)
CASKS=($(cat brew/casks | tr '\n' ' '))
INFO=$(brew info --json=v2 $FORMULAE $CASKS)
MACOS="big_sur"

for item in $(echo -E $INFO | jq -c ".formulae[] | {name, version: .versions.stable, url: .bottle.stable.files.$MACOS.url}") ; do
    name=$(jq -r '.name' <<< $item)
    url=$(jq -r '.url' <<< $item)
    version=$(jq -r '.version' <<< $item)


    # Grab the manifest
    manifest_url="https://ghcr.io/v2/homebrew/core/$name/manifests/$version"
    $CURL $manifest_url > $(brew --cache)/downloads/$(echo -n $manifest_url | shasum -a 256 | head -c 64)--$name-$version.bottle_manifest.json &

    # Grab the tarball
    $CURL $url > $(brew --cache $name) &
done


brew fetch --casks $(cat brew/casks | tr '\n' ' ') >/dev/null &
#brew fetch --force-bottle --deps $(cat brew/formulae | tr '\n' ' ') >/dev/null &

wait

brew install --casks --no-quarantine $(cat brew/casks | tr '\n' ' ')
brew install --force-bottle $(cat brew/formulae | tr '\n' ' ')

#brew cleanup

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
