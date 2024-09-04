FROM --platform=$BUILDPLATFORM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# tools & gadgets
RUN apt-get install -y git  htop gdb g++ clang swig premake4 chrpath gitk \
    cmake m4 patchelf gnuplot-x11 unrar clang-format net-tools \
    systemd-coredump exuberant-ctags silversearcher-ag flake8 jq cpuset

# lib
RUN apt-get install -y default-jre liburiparser-dev uuid-dev zlib1g zlib1g.dev \
    libpython2-dev libcap-dev libsvm-dev liblapacke libelf-dev libgtest-dev \
    liblapack-dev liblapacke-dev liblog4cplus-dev libssl-dev

# lapacke
RUN cd /usr/lib && \
    ln -s /etc/alternatives/lib* ./ && \
    cd /usr/include/ && \
    mkdir lapacke && cd lapacke && \
    ln -s ../lapacke* .

# boost
WORKDIR /tmp
RUN apt-get install -y wget python2-dev tar && \
    wget https://archives.boost.io/release/1.67.0/source/boost_1_67_0.tar.gz && \
    tar -zxf boost_1_67_0.tar.gz && \
    cd boost_1_67_0 && \
    ./bootstrap.sh --with-python=/usr/bin/python2.7 --prefix=/usr/ && \
    ./b2 install -j $(nproc)

# protobuf
WORKDIR /tmp
RUN apt-get install -y wget tar autoconf libtool && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-cpp-3.7.1.tar.gz && \
    tar -zxf protobuf-cpp-3.7.1.tar.gz && \
    cd protobuf-3.7.1 && \
    ./autogen.sh && \
    ./configure && \
    make -j $(nproc) && \
    make -j $(nproc) check && \
    make install

# other configs
RUN sysctl -w vm.nr_hugepages=128

# clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
