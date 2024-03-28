#!/bin/sh
set -e

VERSION=$1

# Get the architecture using uname -m and translate it to the expected format
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    armv7l)
        ARCH="arm"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        echo "Usage: $0 VERSION"
        exit 1
        ;;
esac

# Now ARCH should be one of amd64, arm64, or arm
if [ "$ARCH" = "amd64" ]; then
    echo "https://dl.nssurge.com/snell/snell-server-v${VERSION}-linux-amd64.zip"
elif [ "$ARCH" = "arm64" ]; then
    echo "https://dl.nssurge.com/snell/snell-server-v${VERSION}-linux-aarch64.zip"
elif [ "$ARCH" = "arm" ]; then
    echo "https://dl.nssurge.com/snell/snell-server-v${VERSION}-linux-armv7l.zip"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

exit 0