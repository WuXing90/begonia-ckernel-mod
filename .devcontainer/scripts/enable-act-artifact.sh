#!/bin/sh

export "DIRECTORY=/tmp/act-artifacts"
export "_REMOTE_USER=vscode"
export "_REMOTE_USER_HOME=/home/vscode"

echo "--artifact-server-path ${DIRECTORY}" >> $_REMOTE_USER_HOME/.actrc
chmod +x $_REMOTE_USER_HOME/.actrc
chown $_REMOTE_USER:$_REMOTE_USER $_REMOTE_USER_HOME/.actrc
