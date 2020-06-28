#!/usr/bin/env bash
echo "Starting run.sh"

cat /var/speedtest/config/crontab.default > /var/speedtest/config/crontab

if [[ -z ${CRONJOB_ITERATION} ]]; then
    CRONJOB_ITERATION_SCRIPT="15"
else
    CRONJOB_ITERATION_SCRIPT=${CRONJOB_ITERATION}
fi

#if [[ ${CRONJOB_ITERATION} ]]; then
    sed -i -e "s/0/*\/$CRONJOB_ITERATION_SCRIPT/g" /var/speedtest/config/crontab
    #sed  '0,/\[0\]/i $CRONJOB_ITERATION_SCRIPT' /var/speedtest/config/crontab
#fi
crontab /var/speedtest/config/crontab

echo "Starting Cronjob"
#cron -l 2 -f &
#cron -f

#exit 0;