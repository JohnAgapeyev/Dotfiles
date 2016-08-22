#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -x /usr/bin/cowsay -a -x /usr/bin/fortune ]
  then
    fortune|cowsay
fi

#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
