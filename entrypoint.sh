#!/bin/bash

echo "pull gitfiles"
if [ -d /home/austin/dotfiles ]; then
  cd /home/austin/dotfiles && git pull
else
  cd /home/austin && su austin -c "git clone https://github.com/austinylin/dotfiles"
fi
if [ -f /home/austin/dotfiles/install.sh ]; then
  ./home/austin/dotfiles/install.sh
fi

echo "start tailscale"
tailscaled --state=/data/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=fly-dev --ssh

exec "$@"
