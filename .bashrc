#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export TERM=xterm-256color
export TERMINAL=termite
export VISUAL=nvim
export EDITOR=nvim

#Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi

set GPG TTY
export GPG_TTY=$(tty)

# Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
    gpg-connect-agent /bye >/dev/null 2>&1
fi

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null

function changeaudio() {
    echo "Setting default sink to: $1";
    pacmd set-default-sink $1
    pacmd list-sink-inputs | grep index | while read line
do
    echo "Moving input: ";
    echo $line | cut -f2 -d' ';
    echo "to sink: $1";
    pacmd move-sink-input `echo $line | cut -f2 -d' '` $1
done
}

function mvsane () {
    for F in "$@"
    do
        mv "$F" $(echo "$F" | sed -r 's/[ ]+/_/g' | sed -r 's/[^a-zA-Z0-9_.-]//g' | sed -r 's/[_-]{2,}/-/g')
    done
}
