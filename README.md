# speedtest2mqtt
This image is based on debian linux. Internet download/upload performance is measured with speedtest cli from ookla (https://www.speedtest.net/apps/cli) and results are pushed to mqtt local server. Script can also scrap current download/upload data from wan port on Asus router (tested on RT-AC86U). 

# Docker
You can get the publicly available docker image here: samo27/speedtest2mqtt.

# Environment variables
| Variable | Type | Usage | Example value | Default |
| --- | --- | --- | --- | --- |
| CRONJOB_ITERATION | integer | Time between speedtests in minutes. Value 15 means the cronjob runs every 15 minutes. | 30 | 15 |
| MQTT_HOST | string | IPv4 address of your MQTT broker | 192.168.1.14 | 192.168.1.14 |
| MQTT_PORT | integer | Port for MQTT broaker | 1883 | 1833 |
| MQTT_TOPIC | string | Base topic for MQTT | Domek/speedtest | Domek/speedtest |
| MQTT_OPTIONS | string | Additional settings for MQTT | | none |
| SPEEDTEST_OPTIONS | string | Additional settiongs for speedtest | --server-id=2198 | none |
| ASUS_USER | string | Username for SSH access to Asus router. Leave this empty if you don't want to scrap download/upload from router. | youruser | none |
| ASUS_PWD | string | Password for SSH access to Asus router. Leave this empty if you don't want to scrap download/upload from router. | yourpass | none |
| ASUS_IP | string | IPv4 of your router. Usualy your network gateway. Leave this empty if you don't want to scrap download/upload from router. | 192.168.1.1 | none |
| ASUS_PORT | integer | SSH port for your router. Leave this empty if you don't want to scrap download/upload from router. | 2222 | none |

# MQTT topics
You have to set your base topic in MQTT_TOPIC. Available subscriptions:
| Topic name | Value |
| --- | --- |
| Speedtest ping in ms | $MQTT_TOPIC/ping |
| Speedtest Download in Mbits | $MQTT_TOPIC/download |
| Speedtest Upload in Mbits | $MQTT_TOPIC/upload |
| WAN Download in Mbits | $MQTT_TOPIC/wandownload |
| WAN Upload in Mbits | $MQTT_TOPIC/wanupload |

###### Example 
If you want to subscribe to the topic for speedtest download and base topic is *internetspeed/test*: **internetspeed/test/download**
