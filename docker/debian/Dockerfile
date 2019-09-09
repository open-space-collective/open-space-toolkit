################################################################################################################################################################

# @project        Libraries
# @file           docker/debian/Dockerfile
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

FROM debian:buster

LABEL maintainer="lucas.bremond@gmail.com"

# Aliases

RUN alias ls='ls --color=auto' \
 && alias ll='ls -halF'

# Common Tools

RUN apt update -y \
 && apt install -y \
    git \
    curl \
    wget \
    nano \
    htop \
    tree \
 && apt clean all

# Development Tools

## GCC / GDB / lcov

RUN apt update -y \
 && apt install -y gcc gdb lcov doxygen \
 && apt clean all

## Python [3.7]

RUN apt update -y \
 && apt install -y python3 python3-pip python3-dev python3-numpy \
 && apt clean all

RUN python3 -m pip install --user --upgrade setuptools wheel twine pytest

## CMake [3.15.2]

RUN cd /tmp \
 && wget --quiet https://cmake.org/files/v3.15/cmake-3.15.2.tar.gz \
 && tar -xf cmake-3.15.2.tar.gz \
 && cd cmake-3.15.2 \
 && ./bootstrap \
 && make -j $(nproc) \
 && make install \
 && rm -rf /tmp/cmake-3.15.2 /tmp/cmake-3.15.2.tar.gz

## GoogleTest [1.8.1]

RUN cd /tmp \
 && git clone --branch release-1.8.1 --depth 1 https://github.com/google/googletest.git \
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
 && echo "using python : 3.7 : /usr : /usr/include/python3.7m ;" >> project-config.jam \
 && ./b2 -j $(nproc) link=static cxxflags=-fPIC install \
 && ./b2 -j $(nproc) python=3.7 link=shared cxxflags=-fPIC install \
 && rm -rf /tmp/boost_1_69_0 /tmp/boost_1_69_0.tar.gz

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
