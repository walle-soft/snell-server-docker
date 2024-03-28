#!/bin/bash

set -e

BIN="/usr/bin/snell-server"
CONF="/etc/snell/snell-server.conf"

# reuse existing config when the container restarts

run_bin() {
    echo "Running snell-server with config:"
    echo ""
    cat ${CONF}

    ${BIN} --version
    ${BIN} -c ${CONF}
}

if [ -f ${CONF} ]; then
    echo "Found existing config, rm it."
    rm ${CONF}
fi

if [ -z ${PSK} ]; then
    PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
    echo "Using generated PSK: ${PSK}"
else
    echo "Using predefined PSK: ${PSK}"
fi

echo "Generating new config..."
echo "[snell-server]" >> ${CONF}
echo "listen = :::9102" >> ${CONF}
echo "psk = ${PSK}" >> ${CONF}

# Check if the OBFS environment variable is set
if [ ! -z ${OBFS} ]; then
    echo "obfs = ${OBFS}" >> ${CONF}
    echo "Using obfuscation mode: ${OBFS}"
fi

run_bin
