################################################################################################################################################################

# @project        Libraries
# @file           tools/development/docker/Dockerfile
# @author         Lucas Brémond <lucas@loftorbital.com>
# @license        TBD

################################################################################################################################################################

FROM fedora:27

LABEL maintainer="lucas@loftorbital.com"

# Arguments

ARG version
ARG cpu_count=1

# Environment

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

RUN alias ls='ls --color=auto' \
    && alias ll='ls -halF'

# Common tools

RUN dnf update -y \
    && dnf install -y 'dnf-command(config-manager)' \
    && dnf install -y \
    wget \
    nano \
    htop \
    tree \
    && dnf clean all

# Development Tools

## Compilers

RUN dnf install -y \
    rpm-build \
    ncurses ncurses-devel \
    python python-devel \
    && dnf group install -y "Development Tools" \
    && dnf install -y gcc-c++ gdb lcov \
    && dnf clean all

## CMake [3.11.3]

RUN mkdir /tmp/cmake \
    && cd /tmp/cmake \
    && wget --quiet https://cmake.org/files/v3.11/cmake-3.11.3.tar.gz \
    && tar -xvf cmake-3.11.3.tar.gz \
    && cd cmake-3.11.3 \
    && ./bootstrap \
    && make -j ${cpu_count} \
    && make install \
    && rm -rf /tmp/cmake

## GoogleTest [???]

RUN pushd /tmp > /dev/null \
    && git clone https://github.com/google/googletest.git \
    && cd googletest \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j ${cpu_count} \
    && make install \
    && popd > /dev/null \
    && rm -rf /tmp/googletest

# Dependencies

## Boost [1.67.0]

RUN mkdir /tmp/boost \
    && cd /tmp/boost \
    && wget --quiet http://sourceforge.net/projects/boost/files/boost/1.67.0/boost_1_67_0.tar.gz \
    && tar -xvf boost_1_67_0.tar.gz \
    && cd boost_1_67_0 \
    && ./bootstrap.sh \
    && ./b2 -j ${cpu_count} link=static cxxflags=-fPIC install \
    && rm -rf /tmp/boost

# Labels

ENV version ${version}

LABEL version="${version}"

# Execution

CMD ["/bin/bash"]

################################################################################################################################################################