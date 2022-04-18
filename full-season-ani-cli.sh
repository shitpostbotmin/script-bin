#!/bin/bash
# globals
media_dir="/mnt/media/Anime" # target location

# validate args
if (( $# != 5 )); then
    >&2 echo "Usage: full-season-ani-cli <query> <show name> <show season #> <start ep #> <end ep #>"
    >&2 echo "Example: full-season-ani-cli \"zombie land saga revenge\" \"Zombie Land Saga\" 2 1 12"
    exit
fi

#load args
query=$1
show_name=$2
show_season=$3
start_episode=$4
end_episode=$5

# make new anime directory from the query
mkdir -p "$media_dir/$2"
cd "$media_dir/$2"

# build the ani-cli command and run it
episode_list="$(seq -s ' ' $start_episode $end_episode)"
ani-cli -a "$episode_list" -d "$query"

# rename all the new files
ls | while read file ; do
    season="S0$(echo "$show_season")E$(echo $file | sed -r -n 's/^.*[0-9]([0-9]{2}).*$/\1/gp')";
    ext=$(echo $file | sed -E 's/(.+)(\.)(.*$)/\3/g');
    mv "$file" "$show_name - $season.$ext";
done;
