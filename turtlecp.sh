#!/bin/bash


git pull

cd ~/minecraft-server

for filename in /scripts do
    basename = $(echo "$filename" | cut -f 1 -d '.')

    for turtle in $MINECRAFT_DATA/computer/*/ do
        path = "${MINECRAFT_DATA}/computer/${turtle}/${basename}"
        cp $basename $path
        chmod 777 $path
    done
done