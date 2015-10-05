#!/bin/bash

echo "Fakku downloader"

if [ "$1" == "" ]
then
  echo "Error: no link provided!"
  exit 1
fi

echo
echo "Link: $1"
echo "Downloading page..."

PAGE="$(wget -O - -q "$1")"
if [ $? -ne 0 ]
then
  echo "Error: can't download page!"
  exit 2
fi

echo "Done!"

BASEURL=$(echo "$PAGE" | grep 'images/' | awk -F "'" '{printf $2}')
COUNTPAGE=$(echo "$PAGE" | grep -m1 'window.params.thumbs')
COUNT=$(echo ${COUNTPAGE: -20} | sed 's/\(.*\)\([0-9]\{3\}\)\(.*\)/\2/')
NAME=$(echo "$1" | sed 's/\(.*manga\|.*doujinshi\)\/\(.*\)\/read/\2/')

if [ "$BASEURL" == "" ]
then
  echo "Error: can't find base URL. Make sure you have provided the link to \"Read Online\""
  exit 3
fi
if [ "$NAME" == "" ]
then
  echo "Error: can't find manga name"
  exit 4
fi

echo "Found $COUNT images"

mkdir "$NAME"
cd "$NAME"

for i in $(seq -f '%03.f' $COUNT)
do
  echo "Downloading $i"
  wget -q "$BASEURL""$i"".jpg"
done
