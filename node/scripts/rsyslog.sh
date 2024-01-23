#!/bin/bash

docker rm --force rsyslog
sudo rm -fr /tmp/{conf,log}
mkdir -p /tmp/{conf,log}
touch /tmp/log/syslog

cat > /tmp/conf/10_config.conf << EOF
input(type="imudp" port="5140")
input(type="imtcp" port="5140")

*.*;auth,authpriv.none          -/var/log/syslog
EOF
      
docker run -d --name rsyslog  --network="host" -v /tmp/conf:/etc/rsyslog.d  -v /tmp/log/syslog:/var/log/syslog  levonet/rsyslog