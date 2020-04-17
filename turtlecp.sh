#!/bin/bash


git pull

cd ~/minecraft-server

for filename in /scripts; do
    echo $filename
    basename=$(echo "$filename" | cut -f 1 -d '.')
    echo "basename: ${basename}"
    for turtle in $MINECRAFT_DATA/computer/*/; do
        path = "${MINECRAFT_DATA}/computer/${turtle}/${basename}"
        echo "path: ${path}"
        cp $basename $path
        chmod 777 $path
    done
done