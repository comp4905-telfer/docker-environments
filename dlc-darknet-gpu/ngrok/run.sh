#!/bin/bash
python3 replace-env.py ngrok-config.yml.template ngrok-config.yml
./ngrok start jupyter -config=ngrok-config.yml

