#!/bin/bash

# parameters for MQTT
if [[ -z ${MQTT_HOST} ]]; then
    MQTT_HOST_SCRIPT="-h 192.168.1.14"
else
    MQTT_HOST_SCRIPT="-h "$MQTT_HOST
fi

if [[ -z ${MQTT_PORT} ]]; then
    MQTT_PORT_SCRIPT="-p 1883"
else
    MQTT_PORT_SCRIPT="-p "$MQTT_PORT
fi

if [[ -z ${MQTT_TOPIC} ]]; then
    MQTT_TOPIC_SCRIPT="Domek/speedtest"
else
    MQTT_TOPIC_SCRIPT=${MQTT_TOPIC}
fi

if [[ -z ${MQTT_OPTIONS} ]]; then
    MQTT_OPTIONS_SCRIPT=""
else
    MQTT_OPTIONS_SCRIPT=${MQTT_OPTIONS}
fi

PARAMS=$MQTT_HOST_SCRIPT" "$MQTT_PORT_SCRIPT" "$MQTT_OPTIONS_SCRIPT

# adjust path if neccessary, add arguments here for host/port/user/password/retain/tls
PUB_CMD="/usr/bin/mosquitto_pub "$PARAMS

if [[ -z ${SPEEDTEST_OPTIONS} ]]; then
    SPEEDTEST_OPTIONS_SCRIPT=""
else
    SPEEDTEST_OPTIONS_SCRIPT="${SPEEDTEST_OPTIONS}"
fi

# adjust path if neccessary, add --server argument if you want to use specific speedtest server
OUTPUT=$(/usr/bin/speedtest -f json --accept-license --accept-gdpr $SPEEDTEST_OPTIONS_SCRIPT)
# test OUTPUT
#OUTPUT="{\"type\":\"result\",\"timestamp\":\"2020-06-28T08:06:41Z\",\"ping\":{\"jitter\":0.23300000000000001,\"latency\":15.484},\"download\":{\"bandwidth\":1120919,\"bytes\":15831864,\"elapsed\":15006},\"upload\":{\"bandwidth\":435312,\"bytes\":4714128,\"elapsed\":11311},\"packetLoss\":0,\"isp\":\"A1 Slovenija\",\"interface\":{\"internalIp\":\"172.17.0.2\",\"name\":\"eth0\",\"macAddr\":\"02:42:AC:11:00:02\",\"isVpn\":false,\"externalIp\":\"146.212.131.115\"},\"server\":{\"id\":2198,\"name\":\"A1 Slovenija\",\"location\":\"Ljubljana\",\"country\":\"Slovenia\",\"host\":\"speedtest.simobil.si\",\"port\":8080,\"ip\":\"80.95.236.25\"},\"result\":{\"id\":\"9a8a9fd2-c07e-4e5e-9e4f-090e4d035d9f\",\"url\":\"https://www.speedtest.net/result/c/9a8a9fd2-c07e-4e5e-9e4f-090e4d035d9f\"}}"

zacetek="{\"type\":\"result\",*"
konec="*}}"

if [[ $OUTPUT == $zacetek ]] && [[ $OUTPUT == $konec ]]; then
    REZULTAT=$(echo $OUTPUT | jq '.ping.latency')
    #echo "$REZULTAT"
    PARAMS="-t \"$MQTT_TOPIC_SCRIPT/ping\" -m \"$REZULTAT\""
    eval "$PUB_CMD $PARAMS"
    echo "$PUB_CMD $PARAMS"

    REZULTAT=$(echo $OUTPUT | jq '.download.bandwidth')
    REZULTAT=$(echo $(($REZULTAT / 1250)) | sed 's/..$/.&/')
    PARAMS="-t \"$MQTT_TOPIC_SCRIPT/download\" -m \"$REZULTAT\""
    eval "$PUB_CMD $PARAMS"
    echo "$PUB_CMD $PARAMS"

    REZULTAT=$(echo $OUTPUT | jq '.upload.bandwidth')
    REZULTAT=$(echo $(($REZULTAT / 1250)) | sed 's/..$/.&/')
    PARAMS="-t \"$MQTT_TOPIC_SCRIPT/upload\" -m \"$REZULTAT\""
    eval "$PUB_CMD $PARAMS"
    echo "$PUB_CMD $PARAMS"

fi

exit 0;