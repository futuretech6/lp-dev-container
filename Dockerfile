FROM --platform=$BUILDPLATFORM ubuntu:22.04

RUN apt-get update

# boost
WORKDIR /tmp
RUN apt-get install -y wget python2-dev tar && \
    wget https://archives.boost.io/release/1.67.0/source/boost_1_67_0.tar.gz && \
    tar -zxf boost_1_67_0.tar.gz && \
    cd boost_1_67_0 && \
    ./bootstrap.sh --with-python=/usr/bin/python2.7 --prefix=/usr/ && \
    ./b2 install -j `nproc -all`

# protobuf
WORKDIR /tmp
RUN apt-get install -y wget tar && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-cpp-3.7.1.tar.gz && \
    tar -zxf protobuf-cpp-3.7.1.tar.gz && \
    cd protobuf-3.7.1 && \
    ./autogen.sh && \
    ./configure && \
    make -j `nproc` && \
    make -j `nproc` check && \
    make install

# other dependencies
RUN apt-get install -y git default-jre

# clean up
RUN rm -rf /tmp/*
