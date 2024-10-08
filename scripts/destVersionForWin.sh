#!/usr/bin/env bash

set -eo pipefail

temp_path="WeChatSetup/temp"
latest_path="WeChatSetup/latest"

download_link="$1"
if [ -z "$1" ]; then
    >&2 echo -e "Missing argument. Using default download link"
    download_link="https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe"
fi

function install_depends() {
    printf "#%.0s" {1..60}
    echo 
    echo -e "## \033[1;33mInstalling 7zip, shasum, wget, curl, git\033[0m"
    printf "#%.0s" {1..60}
    echo 

    apt install -y p7zip-full p7zip-rar libdigest-sha-perl wget curl git
}

function download_wechat() {
    printf "#%.0s" {1..60}
    echo 
    echo -e "## \033[1;33mDownloading the newest WechatSetup...\033[0m"
    printf "#%.0s" {1..60}
    echo 

    wget -q "$download_link" -O ${temp_path}/WeChatSetup.exe
    if [ "$?" -ne 0 ]; then
        >&2 echo -e "\033[1;31mDownload Failed, please check your network!\033[0m"
        clean_data 1
    fi
}

function extract_version() {
    printf "#%.0s" {1..60}
    echo 
    echo -e "## \033[1;33mExtract WechatSetup, get the dest version of wechat\033[0m"
    printf "#%.0s" {1..60}
    echo 
    
    # new version
    7z x ${temp_path}/WeChatSetup.exe -o${temp_path}/temp
    dest_version=`ls -l ${temp_path}/temp | awk '{print $9}' | grep '^\[[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\]$' | sed -e 's/^\[//g' -e 's/\]$//g'`
}


# rename and replace
function prepare_commit() {
    printf "#%.0s" {1..60}
    echo 
    echo -e "## \033[1;33mPrepare to commit new version\033[0m"
    printf "#%.0s" {1..60}
    echo 

    mkdir -p WeChatSetup/$dest_version
    cp $temp_path/WeChatSetup.exe WeChatSetup/$dest_version/WeChatSetup-$dest_version.exe
    echo "DestVersion: $dest_version" > WeChatSetup/$dest_version/WeChatSetup-$dest_version.exe.sha256
    echo "Sha256: $now_sum256" >> WeChatSetup/$dest_version/WeChatSetup-$dest_version.exe.sha256
    echo "UpdateTime: $(date -u '+%Y-%m-%d %H:%M:%S') (UTC)" >> WeChatSetup/$dest_version/WeChatSetup-$dest_version.exe.sha256
    echo "DownloadFrom: $download_link" >> WeChatSetup/$dest_version/WeChatSetup-$dest_version.exe.sha256
    
}

function clean_data() {
    printf "#%.0s" {1..60}
    echo 
    echo -e "## \033[1;33mClean runtime and exit...\033[0m"
    printf "#%.0s" {1..60}
    echo 

    rm -rfv WeChatSetup/*
    exit $1
}

function main() {
    # rm -rfv WeChatSetup/*
    mkdir -p ${temp_path}/temp
    #login_gh
    ## https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-Readme.md
    # install_depends
    download_wechat

    now_sum256=`shasum -a 256 ${temp_path}/WeChatSetup.exe | awk '{print $1}'`
    local latest_release_version=$(gh release list | grep '_win_' | head -n 1 | awk '{print $2}')
    local latest_sum256=`gh release view $latest_release_version --json body --jq ".body" | awk '/Sha256/{ print $2 }'`
    local latest_version=`gh release view $latest_release_version --json body --jq ".body" | awk '/DestVersion/{ print $2 }'`

    if [ "$now_sum256" = "$latest_sum256" ]; then
        >&2 echo -e "\n\033[1;32mThis is the newest Version!\033[0m\n"
        clean_data 0
    fi
    ## if not the newest
    extract_version
    prepare_commit

    version="${dest_version}_win_$(date -u '+%Y%m%d')"

    gh release create "v$version" ./WeChatSetup/$dest_version/WeChatSetup-$dest_version.exe -F ./WeChatSetup/$dest_version/WeChatSetup-$dest_version.exe.sha256 -t "Wechat v$version"

    clean_data 0
}

main

