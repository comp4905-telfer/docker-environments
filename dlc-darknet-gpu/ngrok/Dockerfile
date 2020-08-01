FROM ubuntu:20.04

WORKDIR /root
COPY ngrok-config.yml.template .
RUN apt-get -y update
RUN apt install -y wget unzip python3

# Download ngrok 
RUN wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN unzip ngrok.zip

# Simple python script to replace environment variables in config file, environement variables must have the form "{ENV_VAR}" (from python formatting)
RUN echo "import os; import sys; fp = open(sys.argv[1], 'r'); s = fp.read().format(**os.environ); fp.close(); fp = open(sys.argv[2], 'w'); fp.write(s);" > replace-env.py