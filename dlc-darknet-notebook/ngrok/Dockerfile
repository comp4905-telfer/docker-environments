FROM ubuntu:20.04

WORKDIR /root
RUN apt-get update
RUN apt install wget

# Download ngrok 
RUN wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN unzip ngrok.zip

ENTRYPOINT [ "/bin/bash" ]