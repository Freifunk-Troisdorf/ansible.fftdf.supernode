#!/bin/bash
INTERFACE="$3"

/usr/local/sbin/batctl if del $INTERFACE
