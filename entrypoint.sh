#!/bin/bash

# Create a user if not done already.
if ! grep "abc" /etc/passwd > /dev/null; then
    groupadd --non-unique --gid "$PGID" abc
    useradd --non-unique --no-create-home --uid "$PUID" --gid "$PGID" abc
fi

# Verify directories exist.
mkdir -p /data
mkdir -p /conf

mkdir -p /data/saves

# Install Factorio if not done already.
if [[ ! -f /data/.factorio-setup ]]; then
    curl -Lo /tmp/factorio.tar.gz "https://www.factorio.com/get-download/$FACTORIO_VERSION/headless/linux64"
    mkdir -p /tmp/factorio
    mkdir -p /data/bin
    tar -C /tmp/factorio -xvf /tmp/factorio.tar.gz
    mv /tmp/factorio/*/* /data/

    touch /data/.factorio-setup
fi

# Set permissions.
chown -R abc:abc /data
chown -R abc:abc /conf

# Run the Factorio server.
if [[ ! -f "/data/saves/$SAVENAME.zip" ]]; then
    su abc -c "/data/bin/x64/factorio --create /data/saves/$SAVENAME.zip"
fi

su abc -c "/data/bin/x64/factorio --server-settings /data/data/server-settings.json\
                                  --server-adminlist /data/data/server-admins.json\
                                  --server-whitelist /data/data/server-whitelist.json\
                                  --server-banlist /data/data/server-banlist.json\
                                  --rcon-password $RCON_PASSWORD\
                                  --start-server /data/saves/$SAVENAME.zip"