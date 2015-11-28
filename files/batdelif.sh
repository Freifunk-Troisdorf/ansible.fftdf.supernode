#!/bin/bash
INTERFACE="$3"

/usr/sbin/batctl if del $INTERFACE
