FROM maven:3.3.9-jdk-7

MAINTAINER Jean-Francois Caty

ENV HOME ""

RUN ls /etc > /dev/stderr
RUN ls /etc/apt > /dev/stderr

RUN echo "deb http://mirrors.kernel.org/ubuntu trusty main" > /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

RUN apt-get update
RUN apt-get install -y protobuf-compiler
