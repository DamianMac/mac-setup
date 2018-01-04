#!/usr/bin/env bash

brews=(
  git
  mackup
  node
  python
  python3
  mas
  terraform
)

casks=(
  docker
  dropbox
  firefox
  google-chrome 
  skype
  slack
  spotify
  visual-studio-code
  royal-tsx
  typora
  dotnet-sdk
  powershell
  garmin-express
  microsoft-office
  paralells
  psequel
)

pips=(
  pip
  awscli
)

gems=(
  jekyll
)

npms=(
    http-server
)

apps=(
  
  585829637 #todoist
  1055511498 #dayone
  973134470 #befocused
)

git_configs=(
  "user.name damianmac"
  "user.email damian@damianm.com"

  "core.editor nano"

)

vscode=(
  ms-vscode.csharp
  jchannon.csharpextensions
)


######################################## End of app list ########################################
set +e
set -x

function prompt {
  #read -p "Hit Enter to $1 ..."
  echo "About to $1 ..."
}

if test ! $(which brew); then
  prompt "Install Xcode"
  xcode-select --install

  prompt "Install Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  prompt "Update Homebrew"
  brew update
  brew upgrade
fi



function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    prompt "Execute: $exec"
    if ${exec} ; then
      echo "Installed $pkg"
    else
      echo "Failed to execute: $exec"
    fi
  done
}


prompt "Install packages"
brew info ${brews[@]}
install 'brew install' ${brews[@]}

prompt "Install software"
brew tap caskroom/cask
brew tap caskroom/drivers
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}

prompt "Installing secondary packages"
install 'pip install --upgrade' ${pips[@]}
install 'gem install' ${gems[@]}
install 'npm install --global' ${npms[@]}
install 'code --install-extension' ${vscode[@]}

prompt "Installing app store apps"
install 'mas install' ${apps[@]}

prompt "Set git defaults"
for config in "${git_configs[@]}"
do
  git config --global ${config}
done


prompt "Cleanup"
brew cleanup
brew cask cleanup


echo "Done!"
