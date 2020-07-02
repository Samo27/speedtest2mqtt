#!/bin/bash
running=$(ifconfig $(nvram get wan0_ifname) | grep "RX bytes" | awk -F[:\(] '{print $2 $4}');

sleep 10s

running1=$(ifconfig $(nvram get wan0_ifname) | grep "RX bytes" | awk -F[:\(] '{print $2 $4}');

echo $running1 $running