#!/bin/sh

set -e

export "PORT=14000"
# export "ACT_CACHE_KEY=foo"
export "TEMPDIR=$(mktemp -d)"
export "_REMOTE_USER=vscode"
export "_REMOTE_USER_HOME=/home/vscode"

if ! command -v docker >/dev/null 2>&1
then
    echo "Cannot find docker command"
    exit 1
fi

export "ACT_CACHE_KEY=$(echo 'BEGIN {
    srand();
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ-_abcdefghijklmnopqrstuvwxyz-_0123456789-_"
    s = "";
    for(i=0;i<20;i++) {
        s = s "" substr(chars, int(rand()*68), 1);
    }
    print s
}' | awk -f -)"

git clone "https://github.com/sp-ricard-valverde/github-act-cache-server" --depth 1 $TEMPDIR

cd $TEMPDIR

echo "
version: \"3\"
services:
  act-cache-server:
    restart: 'unless-stopped'
    build:
      context: .
      args:
        - AUTH_KEY=$ACT_CACHE_KEY
    ports:
      - $PORT:8080
    volumes:
      - github-act-cache-server-cache:/usr/src/app/.caches
      - github-act-cache-server-db:/usr/local/etc/
volumes:
  github-act-cache-server-cache:
  github-act-cache-server-db:
" > docker-compose.yml

docker compose up --build -d

echo "--env ACTIONS_CACHE_URL=http://127.0.0.1:$PORT/
--env ACTIONS_RUNTIME_URL=http://127.0.0.1:$PORT/
--env ACTIONS_RUNTIME_TOKEN=$ACT_CACHE_KEY" >> $_REMOTE_USER_HOME/.actrc
chmod +x $_REMOTE_USER_HOME/.actrc
chown $_REMOTE_USER:$_REMOTE_USER $_REMOTE_USER_HOME/.actrc
