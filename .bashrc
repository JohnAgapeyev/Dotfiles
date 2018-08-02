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

export CC=/usr/bin/gcc
export CXX=/usr/bin/g++

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
        mv "$F" $(echo "$F" | sed -r 's/[ ]+/_/g;s/[^a-zA-Z0-9_.-]//g;s/[_-]{2,}/-/g;')
    done
}

function shellencode () {
    for F in "$@"
    do
        printf '"' && xxd -g 0 $F | awk '{print $2}' | fold -w2 | awk '{print "\\x" $1}' | tr -d '\n' && echo '"'
    done
}

function repeat () {
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}

function hexlines() {
    LIN=$1
    WID=$2
    if [ $(($WID%2)) -eq 0 ]; then
        head -c $(($LIN * $WID / 2)) /dev/urandom | xxd -g0 -| awk '{print $2}' | tr -d '\n' | fold -w$WID && echo
    else
        head -c $(($LIN * $(($WID / 2 + 1)))) /dev/urandom | xxd -g0 -| awk '{print $2}' | tr -d '\n' | fold -w$WID | head -n $LIN
    fi
}

function newhex() {
    BYTE_COUNT=$(($1 * $2))
    dd iflag=count_bytes if=/dev/urandom count=$BYTE_COUNT 2> /dev/null | xxd -g 0 -c $2 | awk '{print $2}'
}

function convertsnip () {
    for F in "$@"
    do
        cat "$F" | sed -r 's/^#.*//' |  sed -r 's/(^snippet)/\nendsnippet\n\1/' | sed -r '0,/endsnippet/ s///' | sed '/^$/N;/^\n$/D'| sed -r 'N;s/\n+(endsnippet)/\1/' | sed -r 's/(snippet \w+) (\w+[ ]?)+/\1 "\2"/' > "$F".conv && echo endsnippet >> "$F".conv
        mv "$F".conv "$F"
    done
}

function mergefiles() {
    for F in "$@"
    do
        cat $F~ >> $F
    done
}
