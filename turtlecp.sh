#!/bin/bash


git pull

cd ~/minecraft-server

for filename in scripts/*; do
    echo "$filename"
    basename=$(echo "$filename" | cut -f 1 -d '.')
    basename=$(basename "$basename")
    echo "basename: ${basename}"
    for turtle in $MINECRAFT_DATA/computer/*/; do
        path="${turtle}${basename}"
        echo "path: ${path}"
        cp $filename $path
        chmod 777 $path
    done
done