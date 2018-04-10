#!/bin/bash
if [ -e $2 ]; then
    echo "File already exists"
    exit 1
else
    touch $2
fi
if [ $1 = "events" ]; then
    sedSearch='\.EV.'
else
    sedSearch='\.TXT'
fi
find -follow > $2
sed -in "/$sedSearch$/!d" $2
#sed -in '/\.TXT$/!d' $1
