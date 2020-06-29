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

# start cron
service cron start

# trap SIGINT and SIGTERM signals and gracefully exit
trap "service cron stop; kill \$!; exit" SIGINT SIGTERM

# start "daemon"
while true
do
    # watch /var/log/cron.log restarting if necessary
    cat /var/log/cron.log & wait $!
    sleep 10m
done

exit 0;