#!/bin/bash

files=( dist/*.tar.gz )
echo "Asset files:"
( IFS=$'\n'; echo "${files[*]}" )

file=$(basename "${files[0]}")

project=$(echo $file | cut -d'_' -f 1)
version=$(echo $file | cut -d'_' -f 2)

sha512_file="${project}_${version}_sha512-checksums.txt"

cd dist

shasum -a 512 ./*.tar.gz > "${sha512_file}"
