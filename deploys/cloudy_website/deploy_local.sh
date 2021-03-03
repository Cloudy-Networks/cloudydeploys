  #!/bin/bash
  hostnamectl set-hostname www.cloudynet.work
  sed '9 a 127.0.0.1   www.cloudynet.work www' /etc/hosts
  sudo apt -y update && sudo apt -y upgrade
  sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
  sudo curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/gpg/gpg.155B6D79CA56EA34.key' | sudo apt-key add -
  sudo curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/setup/config.deb.txt?distro=debian&version=any-version' | sudo tee -a /etc/apt/sources.list.d/caddy-stable.list
  sudo apt -y update && sudo apt -y install caddy
  sudo rm /usr/share/caddy/index.html
  sudo aws s3 cp "s3://spotrunner.ig.dev/www/" "/usr/share/caddy/" --recursive
  sudo chown -R admin:admin /usr/share/caddy/api/
  sed -i 's/:80/www.cloudynet.work/g' /etc/caddy/Caddyfile
  sudo aws s3 cp s3://spotrunner.ig.dev/api.sh /usr/local/bin/
  sudo chmod +x  /usr/local/bin/api.sh
  reboot

  ####### NOTE: I am adding this for troubleshotting...
  ## sudo has been inserted to allow this to be pasted locally
  ## as it runs as root durring instance startup... but later you
  ## are "admin"
