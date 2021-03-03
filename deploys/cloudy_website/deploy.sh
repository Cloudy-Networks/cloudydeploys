  #!/bin/bash
  hostnamectl set-hostname www.kinda.cloudynet.work
  sed '9 a 127.0.0.1   www.kinda.cloudynet.work www' /etc/hosts
  apt -y update && apt -y upgrade
  apt install -y debian-keyring debian-archive-keyring apt-transport-https
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/gpg/gpg.155B6D79CA56EA34.key' | sudo apt-key add -
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/setup/config.deb.txt?distro=debian&version=any-version' | sudo tee -a /etc/apt/sources.list.d/caddy-stable.list
  apt -y update && apt -y install caddy
  rm /usr/share/caddy/index.html
  aws s3 cp s3://spotrunner.ig.dev/www/ /usr/share/caddy/ --recursive
  chown -R admin:admin /usr/share/caddy/api/
  sed -i 's/:80/www.kinda.cloudynet.work/g' /etc/caddy/Caddyfile
  aws s3 cp s3://spotrunner.ig.dev/api.sh /usr/local/bin/
  chmod +x  /usr/local/bin/api.sh
  reboot

### Note, if you don't have proper resolving DNS working
### remove the bits for mangling the hostname and dns
### otherwise Caddy will be unhappy and of course, no working SSL.
