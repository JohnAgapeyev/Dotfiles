#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tree='tree -C'

alias cmaker='cmake -DCMAKE_BUILD_TYPE=Release'
alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug'

alias vinit='python3 -m venv .venv'
alias venter='source ./.venv/bin/activate'
alias vleave='deactivate'

# History of a single file in a repo
alias gitwhat='git log -p -M --follow --stat --'

#Disable Ctrl-S/Ctrl-Q shenanigans
stty -ixon

# **/* recurse
shopt -s globstar

PS1="\[\e[34m\][\D{%T}]\[\e[36m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\[\e[33m\]\W\[\e[m\]\$ "

export TERM=xterm-256color
export TERMINAL=alacritty
export VISUAL=nvim
export EDITOR=nvim

export MANPAGER='nvim +Man!'

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"

export GCC_COLOR=1

export QT_QPA_PLATFORMTHEME=qt5ct
export QT_SCALE_FACTOR_ROUNDING_POLICY=Round

export ANSIBLE_NOCOWS=1

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
        FP=$(realpath -- "$F")
        BN=$(basename -- "$FP")
        BP=$(dirname -- "$FP")
        NN="${BP}/$(sed -r 's/[ ]+/_/g;s/[^a-zA-Z0-9_.-]//g;s/[_-]{2,}/-/g;s/(^[ _-]+|[ _-]+$)//g' <<< \"${BN}\")"
        [ "$FP" != "$NN" ] && mv -T -- "$FP" "$NN"
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

function convertsnip () {
    for F in "$@"
    do
        cat "$F" | sed -r 's/^#.*//' |  sed -r 's/(^snippet)/\nendsnippet\n\1/' | sed -r '0,/endsnippet/ s///' | sed '/^$/N;/^\n$/D'| sed -r 'N;s/\n+(endsnippet)/\1/' | sed -r 's/(snippet \w+) (\w+[ ]?)+/\1 "\2"/' > "$F".conv && echo endsnippet >> "$F".conv
        mv "$F".conv "$F"
    done
}

#thanks to this https://gist.github.com/timperez/7892680 im adding whoisport
function whoisport () {
    port=$1
    pidInfo=$(fuser $port/tcp 2> /dev/null)
    pid=$(echo $pidInfo | cut -d':' -f2)
    ls -l /proc/$pid/exe
}

#test truecolor support (youll know if it doesnt work)
function truecolortest () {
    awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,colnum+1,1);
        }
        printf "\n";
    }'
}

#for testing ricing colors
function colortest () {
    ansi_mappings=(
    Black
    Red
    Green
    Yellow
    Blue
    Magenta
    Cyan
    White
    Bright_Black
    Bright_Red
    Bright_Green
    Bright_Yellow
    Bright_Blue
    Bright_Magenta
    Bright_Cyan
    Bright_White
    )
    colors=(
    base00
    base08
    base0B
    base0A
    base0D
    base0E
    base0C
    base05
    base03
    base08
    base0B
    base0A
    base0D
    base0E
    base0C
    base07
    base09
    base0F
    base01
    base02
    base04
    base06
    )
    for padded_value in `seq -w 0 21`; do
        color_variable="color${padded_value}"
        eval current_color=\$${color_variable}
        current_color=$(echo ${current_color//\//} | tr '[:lower:]' '[:upper:]') # get rid of slashes, and uppercase
        non_padded_value=$((10#$padded_value))
        base16_color_name=${colors[$non_padded_value]}
        current_color_label=${current_color:-unknown}
        ansi_label=${ansi_mappings[$non_padded_value]}
        block=$(printf "\x1b[48;5;${non_padded_value}m___________________________")
        foreground=$(printf "\x1b[38;5;${non_padded_value}m$color_variable")
        printf "%s %s %s %-30s %s\x1b[0m\n" $foreground $base16_color_name $current_color_label ${ansi_label:-""} $block
    done;
}

function weather () {
    curl wttr.in
}

function background() {
    eval "$@" &>/dev/null &disown;
}

#generate documentation comments for c style code
function mkcdoc () {
    for F in "$@"
    do
        sed -rf ~/.mkcdoc.sed -i $F
    done
}

# select a saved session and open it
function nvimp() {
    vcmd="$(command -v nvim &>/dev/null && echo nvim || echo vim)"
    if [ $vcmd == "nvim" ]; then
        vfl="$HOME/.local/share/nvim/session"
    else
        vfl="$HOME/.vim/session"
    fi
    file="$(find $vfl -type f | fzf +m -1)"
    if [ -n "$file" ]; then
        vcd="$(grep -em 1 'cd ' "$file")"
        if [ -n "$vcd" ]; then
            ${vcd//\~/$HOME}
        fi
        $vcmd
    fi
}

function localscan () {
    arp-scan --interface=$(ip link | grep 2 | awk '{print $2}' | tr -d ':') -l
}

#sum ints one per line
function total () {
    awk '{s+=$1} END {print s}'
}

function bdiff () {
    if [ $# -ne 2 ]
    then
        echo "usage: bdiff file1 file2"
    else
        diff --color=auto -c --label "$1" --label "$2" <(xxd "$1") <(xxd "$2")
    fi
}

#all my v4 ips on all up interfaces
function allv4 () {
    ip addr show up | grep -v 'lo$' | grep 'inet ' | awk '{print $2}'
}


function mocap () {
    range=$(slop  -lc 0.33,1,0.77,0.4 -f '-video_size %wx%h -i +%x,%y')
    out=$(mktemp '/tmp/cap.XXXX.mp4')
    ffmpeg -y -f x11grab -r 20 $range "$out"
    echo "saved to $out"
}

