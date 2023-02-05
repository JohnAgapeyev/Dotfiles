#!/usr/bin/bash
input="$1"
if [ -z "$input" ]; then
    input=$(find . -type f -iname '*.mkv' -o -iname '*.mp4' | shuf -n 1)
fi
seconds=$(ffprobe -show_format "$input" 2>&1 | grep -oE 'Duration: [0-9:]+' | cut -d' ' -f2 |  awk -F':' '{print $1 * 60 * 60 + $2 * 60 + $3}')
instant=$(shuf -i "0-$seconds" -n 1)
echo $(date +%T -u "-d@$instant") in "$input" > /tmp/randwall
file=$(mktemp -u randwall.XXXXXX.jpg)
ffmpeg -ss "$instant" -i "$input" -vframes 1 -q:v 1 "$file" &>/dev/null
feh --bg-fill "$file"
rm "$file"
