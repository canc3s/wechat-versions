#!/usr/bin/env bash

set -eo pipefail

temp_path="WeChatMac/temp"
latest_path="WeChatMac/latest"

download_link="$1"
if [ -z "$1" ]; then
    >&2 echo -e "Missing argument. Using default download link"
    download_link="https://dldir1.qq.com/weixin/mac/WeChatMac.dmg"
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
    echo -e "## \033[1;33mDownloading the newest WeChatMac...\033[0m"
    printf "#%.0s" {1..60}
    echo 

    wget -q "$download_link" -O ${temp_path}/WeChatMac.dmg
    if [ "$?" -ne 0 ]; then
        >&2 echo -e "\033[1;31mDownload Failed, please check your network!\033[0m"
        clean_data 1
    fi
}

function get_version() {
    local url="https://mac.weixin.qq.com/?t=mac&lang=zh_CN"
    local user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 15_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2.1 Safari/605.1.15"
    local page_content=$(curl -s -A "$user_agent" "$url")
    
    dest_version=$(echo "$page_content" | grep -oP '<p>\K[\d\.]+(?=</p></div>)' | head -n 1)
}


# rename and replace
function prepare_commit() {
    printf "#%.0s" {1..60}
    echo 
    echo -e "## \033[1;33mPrepare to commit new version\033[0m"
    printf "#%.0s" {1..60}
    echo 

    mkdir -p WeChatMac/$dest_version
    cp $temp_path/WeChatMac.dmg WeChatMac/$dest_version/WeChatMac-$dest_version.dmg
    echo "DestVersion: $dest_version" > WeChatMac/$dest_version/WeChatMac-$dest_version.dmg.sha256
    echo "Sha256: $now_sum256" >> WeChatMac/$dest_version/WeChatMac-$dest_version.dmg.sha256
    echo "UpdateTime: $(date -u '+%Y-%m-%d %H:%M:%S') (UTC)" >> WeChatMac/$dest_version/WeChatMac-$dest_version.dmg.sha256
    echo "DownloadFrom: $download_link" >> WeChatMac/$dest_version/WeChatMac-$dest_version.dmg.sha256
    
}

function clean_data() {
    printf "#%.0s" {1..60}
    echo 
    echo -e "## \033[1;33mClean runtime and exit...\033[0m"
    printf "#%.0s" {1..60}
    echo 

    rm -rfv WeChatMac/*
    exit $1
}

function main() {
    # rm -rfv WeChatSetup/*
    mkdir -p ${temp_path}/temp
    # login_gh
    ## https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-Readme.md
    # install_depends
    download_wechat

    now_sum256=`shasum -a 256 ${temp_path}/WeChatMac.dmg | awk '{print $1}'`
    local latest_release_version=$(gh release list | grep '_mac_' | head -n 1 | awk '{print $2}')
    local latest_sum256=`gh release view $latest_release_version --json body --jq ".body" | awk '/Sha256/{ print $2 }'`
    local latest_version=`gh release view $latest_release_version --json body --jq ".body" | awk '/DestVersion/{ print $2 }'`
    
    if [ "$now_sum256" = "$latest_sum256" ]; then
        >&2 echo -e "\n\033[1;32mThis is the newest Version!\033[0m\n"
        clean_data 0
    fi
    ## if not the newest
    get_version
    prepare_commit
    # if dest_version is the same as latest_version
    version="${dest_version}_mac_$(date -u '+%Y%m%d')"
    
    gh release create v$version ./WeChatMac/$dest_version/WeChatMac-$dest_version.dmg -F ./WeChatMac/$dest_version/WeChatMac-$dest_version.dmg.sha256 -t "Wechat v$version"

    clean_data 0
}

main
