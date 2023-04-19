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

## Python installing dependencies

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    build-essential \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    libffi-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

## Python [3.6.12]

RUN mkdir -p /tmp/py36 \
 && cd /tmp/py36 \
 && wget --quiet https://www.python.org/ftp/python/3.6.12/Python-3.6.12.tgz \
 && tar -xzf Python-3.6.12.tgz \
 && cd Python-3.6.12 \
 && ./configure --enable-optimizations \
 && make altinstall \
 && rm -rf /tmp/py36

## Python [3.9.16]

RUN mkdir -p /tmp/py39 \
 && cd /tmp/py39 \
 && wget --quiet https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz \
 && tar -xzf Python-3.9.16.tgz \
 && cd Python-3.9.16 \
 && ./configure --enable-optimizations \
 && make altinstall \
 && rm -rf /tmp/py39

## Python [3.10.9]

RUN mkdir -p /tmp/py310 \
 && cd /tmp/py310 \
 && wget --quiet https://www.python.org/ftp/python/3.10.9/Python-3.10.9.tgz \
 && tar -xzf Python-3.10.9.tgz \
 && cd Python-3.10.9 \
 && ./configure --enable-optimizations \
 && make altinstall \
 && rm -rf /tmp/py310

## Python [3.11.1]

RUN mkdir -p /tmp/py311 \
 && cd /tmp/py311 \
 && wget --quiet https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz \
 && tar -xzf Python-3.11.1.tgz \
 && cd Python-3.11.1 \
 && ./configure --enable-optimizations \
 && make altinstall \
 && rm -rf /tmp/py311

## Python tools

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    python3-dev \
    python3-numpy \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*

RUN python3.6 -m pip install --upgrade pip \
 && python3.7 -m pip install --upgrade pip \
 && python3.8 -m pip install --upgrade pip \
 && python3.9 -m pip install --upgrade pip \
 && python3.10 -m pip install --upgrade pip \
 && python3.11 -m pip install --upgrade pip \
 && python3 -m pip install --user --upgrade pip setuptools wheel twine pytest \
 && python3.6 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.7 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.9 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.10 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.11 -m pip install --user --upgrade setuptools wheel twine pytest

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

## Boost [1.82.0]

ARG BOOST_MAJOR_VERSION="1"
ARG BOOST_MINOR_VERSION="82"
ARG BOOST_VERSION="${BOOST_MAJOR_VERSION}.${BOOST_MINOR_VERSION}.0"

RUN cd /tmp \
 && wget --quiet -O boost_${BOOST_VERSION}.tar.gz https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_0.tar.gz/download \
 && tar -xf boost_${BOOST_VERSION}.tar.gz \
 && cd boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_0 \
 && ./bootstrap.sh \
 && echo "using python : 3.8 : /usr : /usr/include/python3.8m ;" >> project-config.jam \
 && ./b2 -j $(nproc) link=static cxxflags=-fPIC install \
 && ./b2 -j $(nproc) python=3.8 link=shared cxxflags=-fPIC install \
 && rm -rf /tmp/boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_0 /tmp/boost_${BOOST_VERSION}.tar.gz

## Pybind11 [2.10.3]

RUN mkdir /tmp/pybind11 \
 && cd /tmp/pybind11 \
 && wget http://ftp.us.debian.org/debian/pool/main/p/pybind11/pybind11-dev_2.10.3-1_all.deb \
 && apt-get install -y ./pybind11-dev_2.10.3-1_all.deb \
 && rm -rf /tmp/pybind11

# Environment

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH /usr/local/lib:${PYTHONPATH}
RUN git config --global --add safe.directory /app

# Labels

ARG VERSION

ENV VERSION ${VERSION}

LABEL VERSION="${VERSION}"

# Execution

CMD ["/bin/bash"]

################################################################################################################################################################
