FROM debian

ENV \
    CRONJOB_ITERATION="30" \
    MQTT_HOST="192.168.1.14" \
    MQTT_PORT="1883" \
    MQTT_TOPIC="Domek/speedtest" \
    MQTT_OPTIONS="" \
    SPEEDTEST_OPTIONS="--server-id=2198" \
    ASUS_USER="" \
    ASUS_PWD="" \
    ASUS_IP="" \
    ASUS_PORT="" 

RUN apt-get update
RUN apt-get install -y \
    gnupg1 \
    apt-transport-https \
    dirmngr \
    lsb-release \
    mosquitto-clients \
    jq \
    ssh \
    bash \
    cron \
    sshpass \
    bc
RUN export INSTALL_KEY=379CE192D401AB61 && \
    export DEB_DISTRO=$(lsb_release -sc) && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY && \
    echo "deb https://ookla.bintray.com/debian ${DEB_DISTRO} main" | tee  /etc/apt/sources.list.d/speedtest.list
RUN apt-get update
RUN apt-get install speedtest

RUN mkdir /var/speedtest
RUN mkdir /var/speedtest/config
RUN mkdir /var/speedtest/scripts
RUN touch /var/log/cron.log

ADD ./scripts/. /var/speedtest/scripts/
ADD ./config/. /var/speedtest/config/

RUN chmod 777 /var/speedtest/scripts/speedtest.sh
RUN chmod 777 /var/speedtest/scripts/wanspeed.sh
RUN chmod 777 /var/speedtest/config/run.sh
RUN chmod 777 /var/log/cron.log

CMD [ "/var/speedtest/config/run.sh" ]
