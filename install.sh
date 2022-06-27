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

if [[ -eq "$(uname -p)" "arm" ]] ; then
    BREW=/opt/homebrew/bin/brew
else
    BREW=/usr/local/bin/brew
fi

if ! [[ -e "/Library/Developer/CommandLineTools/usr/bin/git" ]]
then
  # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
  brew_placeholder="/Library/Developer/CommandLineTools/usr/bin/git"
  clt_placeholder="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
  sudo touch $clt_placeholder $brew_placeholder

  clt_label_command="/usr/sbin/softwareupdate -l |
                      grep -B 1 -E 'Command Line Tools' |
                      awk -F'*' '/^ *\\*/ {print \$2}' |
                      sed -e 's/^ *Label: //' -e 's/^ *//' |
                      sort -V |
                      tail -n1"
  clt_label="$(chomp "$(/bin/bash -c "${clt_label_command}")")"

  if [[ -n "${clt_label}" ]]
  then
    echo "installing ${clt_label}"
    sudo "/usr/sbin/softwareupdate" "-i" "${clt_label}"
    sudo "/usr/bin/xcode-select" "--switch" "/Library/Developer/CommandLineTools"
  fi
  sudo "/bin/rm" "-f" "${clt_placeholder}" "${brew_placeholder}"
fi &

if ! command -v $BREW ; then # TODO(Darwin)
  echo 'installing homebrew (requires sudo)'
  /usr/bin/sudo -v
  /bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/9d6f09136c472978b4b18294d895010077008744/install.sh)"
  $BREW install git
fi

if [ ! -d $HOME/src ]; then
  echo 'creating ~/src'
  mkdir $HOME/src
fi

pushd $HOME/src

if [ ! $HOME/.ssh ]; then
  echo "creating an SSH key... don't forget to add it to https://github.com/account/ssh"
  ssh-keygen -t rsa
  ssh-keyscan github.com > $HOME/.ssh/known_hosts
fi

if [ ! -d $HOME/src/dotfiles ]; then
  echo 'cloning dotfiles into ~/src'
  git clone https://github.com/blampe/dotfiles.git
  cd dotfiles # TODO(remove)
  git checkout origin/refactor # TODO(remove)
fi

pushd $HOME/src/dotfiles

if [ $CASKS ] ; then
  for tap in $(cat brew/taps); do
    $BREW tap $tap
  done
fi

# Take the requested formulae/casks and subtract any that are already installed
INSTALLED="$(for fullname in $(brew list -1 --full-name); do basename $fullname; done | sort)"
FORMULAE=($(comm -23 <(cat brew/formulae) <(echo $INSTALLED) | tr '\n' ' '))
CASKS=($(comm -23 <(cat brew/casks) <(echo $INSTALLED) | tr '\n' ' '))

BOTTLE_INFO=$($BREW info --json=v2 --bottle $FORMULAE)
CASK_INFO=$($BREW info --json=v2 $CASKS)

CURL=(curl -k -s --retry 3 --disable --cookie /dev/null --globoff --header 'Authorization: Bearer QQ==' --location)
MACOS="big_sur"

BOTTLES=()
PIDS=()

CACHE_DIR="$($BREW --cache)"

echo "fetching tarballs..."
echo "$FORMULAE"

while read name version url ; do
  url_sha="$(echo -n $url | shasum -a 256 | head -c 64)"
  file="$CACHE_DIR/downloads/$url_sha--$name--$version.$MACOS.bottle.tar.gz"

  BOTTLES+=($file)

  # Grab the tarball
  $CURL $url > $file &
  PIDS+=($!)
done <<< $(echo -E $BOTTLE_INFO | jq -rc ".formulae[] | [.name, .pkg_version, .bottles.$MACOS.url, .bottles.all.url],(.dependencies[] | [.name, .pkg_version, .bottles.$MACOS.url, .bottles.all.url]) | @tsv" | sort | uniq)

echo "$CASKS"

while read url ; do
  url_sha="$(echo -n $url | shasum -a 256 | head -c 64)"
  file="$CACHE_DIR/downloads/$url_sha--$(basename $url)"

  # Grab the tarball
  $CURL $url > $file &
  PIDS+=($!)
done <<< $(echo -E $CASK_INFO | jq -rc ".casks[] | .url")

wait $PIDS

echo "installing bottles and casks..."
HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 $BREW install $BOTTLES
HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 $BREW install --casks $CASKS

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
