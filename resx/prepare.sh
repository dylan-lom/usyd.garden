#!/bin/sh
#
# prepare image for hosting
# 1. strip metadata
# 2. generate thumbnail
set -e

for f in "$@"; do
	if echo "$f" | grep -q '\.thumb\.jpg$'; then
		echo "Skipping thumbnail $f"
		continue
	fi

	echo "Stripping metadata in $f"
	exiftool -all= "$f"

	ext=".$(echo "$f" | rev | cut -d'.' -f1 | rev)"
	thumb="$(basename -s "$ext" "$f").thumb.jpg"
	echo "Generating thumbnail $thumb"
	convert "$f" -resize 500x500 "$thumb"

	git add "$f" "$thumb"
done
