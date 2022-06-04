FROM ubuntu:latest
MAINTAINER Pradip Gupta <pradip.mech13@gmail.com>

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

RUN apt-get update --fix-missing
RUN apt-get -y install --no-install-recommends apt-utils dialog 2>&1
RUN apt-get install -y --fix-missing protobuf-compiler \
                       libsm6 \
                       libxext6 \
                       libxrender-dev \
                       wget make curl unzip git vim bash-completion locales build-essential

WORKDIR /work

COPY ./requirements.txt /work/requirements.txt
COPY ./Makefile /work/Makefile

RUN make install