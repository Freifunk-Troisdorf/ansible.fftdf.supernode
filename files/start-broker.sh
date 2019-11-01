#!/bin/bash

WDIR=/srv/tunneldigger/env_tunneldigger
VIRTUALENV_DIR=/srv/tunneldigger/env_tunneldigger

cd $WDIR
source $VIRTUALENV_DIR/bin/activate

$VIRTUALENV_DIR/bin/python -m tunneldigger_broker.main  ../l2tp_broker.cfg
#bin/python broker/l2tp_broker.py ../l2tp_broker.cfg

