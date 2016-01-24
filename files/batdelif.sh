#!/bin/bash
INTERFACE="$3"

/sbin/brctl delif br-nodes $INTERFACE
