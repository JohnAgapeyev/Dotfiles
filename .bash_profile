#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -x /usr/bin/cowsay -a -x /usr/bin/fortune ]
  then
    fortune|cowsay
fi

