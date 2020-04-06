#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -x /usr/bin/cowsay -a -x /usr/bin/fortune -a -x /usr/bin/lolcat ]
  then
    fortune -a | cowsay | lolcat -t
fi

