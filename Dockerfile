FROM debian

EXPOSE 22

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
    cron
RUN export INSTALL_KEY=379CE192D401AB61 && \
    export DEB_DISTRO=$(lsb_release -sc) && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY && \
    echo "deb https://ookla.bintray.com/debian ${DEB_DISTRO} main" | tee  /etc/apt/sources.list.d/speedtest.list
RUN apt-get update
RUN apt-get install speedtest

RUN mkdir /var/speedtest
RUN mkdir /var/speedtest/config
RUN mkdir /var/speedtest/scripts

ADD ./scripts/. /var/speedtest/scripts/
ADD ./config/. /var/speedtest/config/

RUN chmod 777 /var/speedtest/scripts/speedtest.sh
RUN chmod 777 /var/speedtest/config/run.sh

#CMD [ "speedtest", "--accept-license", "--accept-gdpr", "--server-id=2198" ]
CMD [ "/var/speedtest/config/run.sh" ]
