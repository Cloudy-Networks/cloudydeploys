  #!/bin/bash
  hostnamectl set-hostname oa.cloudynet.work
  sed '9 a 127.0.0.1   oa.cloudynet.work oa' /etc/hosts
  apt -y update && apt -y upgrade
  reboot
