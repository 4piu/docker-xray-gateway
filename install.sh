#!/usr/bin/env sh
#
# This is a Shell script for xray based alpine with Docker image
# 
# Copyright (C) 2019 - 2020 Teddysun <i@teddysun.com>
#
# Reference URL:
# https://github.com/XTLS/Xray-core

PLATFORM=$1
if [ -z "$PLATFORM" ]; then
    ARCH="amd64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="386"
            ;;
        linux/amd64)
            ARCH="amd64"
            ;;
        linux/arm/v6)
            ARCH="arm6"
            ;;
        linux/arm/v7)
            ARCH="arm7"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64"
            ;;
        linux/ppc64le)
            ARCH="ppc64le"
            ;;
        linux/s390x)
            ARCH="s390x"
            ;;
        *)
        
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download binary file
XRAY_FILE="xray_linux_${ARCH}"

echo "Downloading binary file: ${XRAY_FILE}"

wget -O /usr/bin/xray https://dl.lamp.sh/files/${XRAY_FILE}
if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${XRAY_FILE}" && exit 1
fi
echo "Download binary file: ${XRAY_FILE} completed"

chmod +x /usr/bin/xray

# Download geosite.dat and geoip.dat

echo "Downloading geoip.dat"
wget https://hub.fastgit.org/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -O /usr/local/share/xray/geoip.dat
if [ $? -ne 0 ]; then
    echo "Error: Failed to download geoip.dat" && exit 1
fi
echo "Download geoip.dat completed"

echo "Downloading geosite.dat"
wget https://hub.fastgit.org/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -O /usr/local/share/xray/geosite.dat
if [ $? -ne 0 ]; then
    echo "Error: Failed to download geosite.dat" && exit 1
fi
echo "Download geosite.dat completed"
