#!/usr/bin/env bash

set -o errexit
set +o nounset

file="$PWD/package.json"

get_version_config() {
    packageJson=$(cat $file | jq '.engines.node')

    echo $packageJson
}

main() {
    # detect if is set
    if [ "$NODE_VERSION_DETECT" == "$PWD" ]; then
        exit
    fi

    if [ ! -f $file ]; then
        exit
    fi

    version_config=$(get_version_config)

    if [ -z $version_config ]; then
        exit
    fi

    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

    node_version=$(nvm_version $version_config)

    if [ -z $node_version ] || [ "$node_version" == "N/A" ]; then
        echo "cannot parse version $version_config"
        exit
    fi

    node_path=$(nvm_version_path $node_version)

    if [ ! -d $node_path ]; then
        echo "node version $node_version not installed"
        exit
    fi

    node_bin_path="$node_path/bin"

    export PATH=$PATH:$node_bin_path
}

main
