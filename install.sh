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

if [ "$(uname -p)" = "arm" ] ; then
    BREW=/opt/homebrew/bin/brew
else
    BREW=/usr/local/bin/brew
fi

if ! [[ -e "/Library/Developer/CommandLineTools/usr/bin/git" ]]
then
  echo "installing command line tools..."
  sudo "/usr/bin/xcode-select" "--install"
fi

if ! command -v $BREW ; then
  echo "installing homebrew..."
  /usr/bin/sudo -v
  /bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/4b43b8e6c3e854677ae052e3a7f790c20a8c1056/install.sh)"
  $BREW install git
fi

if [ ! -d $HOME/src ]; then
  mkdir $HOME/src
fi

pushd $HOME/src

if [ ! $HOME/.ssh ]; then
  echo "creating an SSH key... don't forget to add it to https://github.com/account/ssh"
  ssh-keygen -t rsa
  ssh-keyscan github.com > $HOME/.ssh/known_hosts
fi

if [ ! -d $HOME/src/dotfiles ]; then
  git clone https://github.com/blampe/dotfiles.git
  cd dotfiles # TODO(remove)
  git checkout origin/refactor # TODO(remove)
fi

pushd $HOME/src/dotfiles

echo "installing homebrew packages..."
$BREW bundle install

echo "installing dotfiles..."
for i in _$1*
do
  link_file "$i"
done

git submodule update --init

echo "installing vim plugins..."
vim +PlugInstall +qall

if [[ `uname` =~ "Darwin" ]]; then
  echo "installing preferences..."
  for i in Library/Preferences/*
  do
      link_file "$i" "${HOME}/$i"
  done

  if [ -f ~/.macos ]; then
      echo "applying macos settings..."
      . ~/.macos
  fi
fi

#if [ ! -d "$HOME/src/gcalcli" ]; then
#  echo 'installing gcalcli'
#  mkdir -p ~/src
#  git clone https://github.com/insanum/gcalcli.git ~/src/gcalcli
#  pushd ~/src/gcalcli
#  python3 -m venv env
#  . env/bin/activate
#  python3 setup.py install
#  deactivate
#  popd
#fi
