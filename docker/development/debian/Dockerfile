################################################################################################################################################################

# @project        Open Space Toolkit
# @file           docker/development/debian/Dockerfile
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

FROM python:3.8-slim-buster

LABEL maintainer="lucas.bremond@gmail.com"

# Aliases

RUN alias ls='ls --color=auto' \
 && alias ll='ls -halF'

# Common Tools

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    nano \
    htop \
    tree \
    wget \
    make \
    libssl-dev \
 && rm -rf /var/lib/apt/lists/*

# Development Tools

## GCC / GDB / lcov / doxygen

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    gdb \
    lcov \
    doxygen \
 && rm -rf /var/lib/apt/lists/*

## Python [3.8]

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    python3-dev \
    python3-numpy \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.7 -m pip install --user --upgrade setuptools wheel twine pytest

## CMake [3.18.4]

RUN cd /tmp \
 && wget --quiet https://cmake.org/files/v3.18/cmake-3.18.4.tar.gz \
 && tar -xf cmake-3.18.4.tar.gz \
 && cd cmake-3.18.4 \
 && ./bootstrap \
 && make -j $(nproc) \
 && make install \
 && rm -rf /tmp/cmake-3.18.4 /tmp/cmake-3.18.4.tar.gz

## GoogleTest [1.10.0]

RUN cd /tmp \
 && git clone --branch release-1.10.0 --depth 1 https://github.com/google/googletest.git \
 && cd googletest \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make -j $(nproc) \
 && make install \
 && rm -rf /tmp/googletest

# Dependencies

## Boost [1.69.0]

RUN cd /tmp \
 && wget --quiet http://sourceforge.net/projects/boost/files/boost/1.69.0/boost_1_69_0.tar.gz \
 && tar -xf boost_1_69_0.tar.gz \
 && cd boost_1_69_0 \
 && ./bootstrap.sh \
 && echo "using python : 3.8 : /usr : /usr/include/python3.8m ;" >> project-config.jam \
 && ./b2 -j $(nproc) link=static cxxflags=-fPIC install \
 && ./b2 -j $(nproc) python=3.8 link=shared cxxflags=-fPIC install \
 && rm -rf /tmp/boost_1_69_0 /tmp/boost_1_69_0.tar.gz

## Pybind11 [2.6.2-1]

RUN mkdir /tmp/pybind11 \
 && cd /tmp/pybind11 \
 && wget http://ftp.us.debian.org/debian/pool/main/p/pybind11/pybind11-dev_2.6.2-1_all.deb \
 && apt-get install -y ./pybind11-dev_2.6.2-1_all.deb \
 && rm -rf /tmp/pybind11

# Environment

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH /usr/local/lib:${PYTHONPATH}

# Labels

ARG VERSION

ENV VERSION ${VERSION}

LABEL VERSION="${VERSION}"

# Execution

CMD ["/bin/bash"]

################################################################################################################################################################
