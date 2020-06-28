#!/usr/bin/env bash
echo "Starting run.sh"

cat /var/speedtest/config/crontab.default > /var/speedtest/config/crontab

if [[ ${CRONJOB_ITERATION} && ${CRONJOB_ITERATION-x} ]]; then
    sed -i -e "s/0/*\/${CRONJOB_ITERATION}/g" /var/speedtest/config/crontab
fi
crontab /var/speedtest/config/crontab

echo "Starting Cronjob"
crond -l 2 -f &

exit 0;