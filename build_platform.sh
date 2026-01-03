#!/bin/bash

ignore_errors=0
platform=debian13
ruby_version=3.2.2
asset_version=${TAG:-local-build}
asset_filename=sensu-ruby32-runtime_${asset_version}_ruby-${ruby_version}_${platform}_linux_amd64.tar.gz
asset_image=sensu-ruby32-runtime-${ruby_version}-${platform}:${asset_version}


if [ "${asset_version}" = "local-build" ]; then
  echo "Local build"
  ignore_errors=1
fi

echo "Platform: ${platform}"
echo "Check for asset file: ${asset_filename}"
if [ -f "$PWD/dist/${asset_filename}" ]; then
  echo "File: "$PWD/dist/${asset_filename}" already exists!!!"
  [ $ignore_errors -eq 0 ] && exit 1
else
  echo "Check for docker image: ${asset_image}"
  if [[ "$(docker images -q ${asset_image} 2> /dev/null)" == "" ]]; then
    echo "Docker image not found...we can build"
    echo "Building Docker Image: sensu-ruby32-runtime:${ruby_version}-${platform}"
    docker build --build-arg "RUBY_VERSION=$ruby_version" --build-arg "ASSET_VERSION=$asset_version" -t ${asset_image} -f Dockerfile.${platform} .
    echo "Making Asset: /assets/${asset_filename}"
    docker run -v "$PWD/dist:/dist" ${asset_image} cp /assets/${asset_filename} /dist/
  else
    echo "Image already exists!!!"
    [ $ignore_errors -eq 0 ] && exit 1
  fi
fi
