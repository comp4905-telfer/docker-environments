#!/bin/bash

if [ $NGROK_ON = true ]
then 
    python3 replace-env.py ngrok-config.yml.template ngrok-config.yml
    ./ngrok start dlc-darknet-gpu tf2 -config=ngrok-config.yml
else 
    echo "ENV configured to not start ngrok"
fi
