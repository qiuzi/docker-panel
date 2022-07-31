#! /bin/bash -eu

if [ "$CONFIG_FILE" != "" ]; then
  echo "[INFO] Config Panel from CONFIG_BASE64 env"
  echo $CONFIG_FILE | base64 -d > config/.config.php
  echo "[INFO] Config Panel from CONFIG_BASE64 completed"
fi
if [ "$DATABASE" = "yse" ]; then
 vendor/bin/phinx migrate && \
 php xcat Tool importAllSettings
 php xcat Tool detectConfigs
 php xcat User createAdmin <<EOF
 echo $ADMINEMAIL
 echo $ADMIMNPASSWD
 Y
EOF
 php xcat Tool initQQwry
fi
if [ "$PORT" = "" ]; then
  PORT=80


fi
envsubst '$PORT' < /nginx.conf.template > /etc/nginx/nginx.conf

supervisord -c /supervisord.conf
