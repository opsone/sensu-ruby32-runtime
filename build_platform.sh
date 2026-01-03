#!/bin/bash

platform=debian13
ruby_version=3.2.2
asset_version=0.1.2
asset_filename=sensu-ruby32-runtime_${asset_version}_ruby-${ruby_version}_${platform}_linux_amd64.tar.gz
asset_image=sensu-ruby32-runtime-${ruby_version}-${platform}:${asset_version}


echo "Platform: ${platform}"
echo "Check for asset file: ${asset_filename}"
if [ -f "$PWD/dist/${asset_filename}" ]; then
  echo "File: "$PWD/dist/${asset_filename}" already exists!!!"
  exit 1
else
  echo "Check for docker image: ${asset_image}"
  if [[ "$(docker images -q ${asset_image} 2> /dev/null)" == "" ]]; then
    echo "Docker image not found...we can build"
    echo "Building Docker Image: sensu-ruby32-runtime:${ruby_version}-${platform}"
    docker build --platform linux/amd64 --build-arg "RUBY_VERSION=$ruby_version" --build-arg "ASSET_VERSION=$asset_version" -t ${asset_image} -f Dockerfile.${platform} .
    echo "Making Asset: /assets/${asset_filename}"
    docker run --platform linux/amd64 -v "$PWD/dist:/dist" ${asset_image} cp /assets/${asset_filename} /dist/
  else
    echo "Image already exists!!!"
    exit 1
  fi
fi
