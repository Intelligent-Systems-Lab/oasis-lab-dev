FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openssh-server

RUN apt-get update && apt-get -y upgrade &&\
    apt-get install -y apt-utils openssh-server software-properties-common &&\
    apt-get install -y autotools-dev automake curl git wget zip build-essential gcc pkg-config net-tools nano

RUN 
