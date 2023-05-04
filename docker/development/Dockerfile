################################################################################################################################################################

# @project        Open Space Toolkit
# @file           docker/development/Dockerfile
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

FROM ubuntu:22.04

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

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    build-essential \
    libncursesw5-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    autotools-dev \
    libicu-dev \
    libffi-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

## Python 3.8

ARG PYTHON_3_8_VERSION="3.8.9"

RUN mkdir -p /tmp/py38 \
 && cd /tmp/py38 \
 && wget --no-check-certificate --quiet https://www.python.org/ftp/python/${PYTHON_3_8_VERSION}/Python-${PYTHON_3_8_VERSION}.tgz \
 && tar -xzf Python-${PYTHON_3_8_VERSION}.tgz \
 && cd Python-${PYTHON_3_8_VERSION} \
 && ./configure --enable-optimizations \
 && make altinstall \
 && rm -rf /tmp/py38

## Python 3.9

ARG PYTHON_3_9_VERSION="3.9.16"

RUN mkdir -p /tmp/py39 \
 && cd /tmp/py39 \
 && wget --no-check-certificate --quiet https://www.python.org/ftp/python/${PYTHON_3_9_VERSION}/Python-${PYTHON_3_9_VERSION}.tgz \
 && tar -xzf Python-${PYTHON_3_9_VERSION}.tgz \
 && cd Python-${PYTHON_3_9_VERSION} \
 && ./configure --enable-optimizations \
 && make altinstall \
 && rm -rf /tmp/py39

## Python 3.10

ARG PYTHON_3_10_VERSION="3.10.9"

RUN mkdir -p /tmp/py310 \
 && cd /tmp/py310 \
 && wget --no-check-certificate --quiet https://www.python.org/ftp/python/${PYTHON_3_10_VERSION}/Python-${PYTHON_3_10_VERSION}.tgz \
 && tar -xzf Python-${PYTHON_3_10_VERSION}.tgz \
 && cd Python-${PYTHON_3_10_VERSION} \
 && ./configure --enable-optimizations \
 && make altinstall \
 && rm -rf /tmp/py310

## Python 3.11

ARG PYTHON_3_11_VERSION="3.11.1"

RUN mkdir -p /tmp/py311 \
 && cd /tmp/py311 \
 && wget --no-check-certificate --quiet https://www.python.org/ftp/python/${PYTHON_3_11_VERSION}/Python-${PYTHON_3_11_VERSION}.tgz \
 && tar -xzf Python-${PYTHON_3_11_VERSION}.tgz \
 && cd Python-${PYTHON_3_11_VERSION} \
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

RUN python3.8 -m pip install --upgrade pip \
 && python3.9 -m pip install --upgrade pip \
 && python3.10 -m pip install --upgrade pip \
 && python3.11 -m pip install --upgrade pip \
 && python3 -m pip install --user --upgrade pip setuptools wheel twine pytest \
 && python3.8 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.9 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.10 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.11 -m pip install --user --upgrade setuptools wheel twine pytest

## CMake

ARG CMAKE_MAJOR_VERSION="3"
ARG CMAKE_MINOR_VERSION="26"
ARG CMAKE_PATCH_VERSION="3"
ARG CMAKE_VERSION="${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}"

RUN cd /tmp \
 && wget --quiet https://cmake.org/files/v${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}/cmake-${CMAKE_VERSION}.tar.gz \
 && tar -xf cmake-${CMAKE_VERSION}.tar.gz \
 && cd cmake-${CMAKE_VERSION} \
 && ./bootstrap \
 && make -j $(nproc) \
 && make install \
 && rm -rf /tmp/cmake-${CMAKE_VERSION} /tmp/cmake-${CMAKE_VERSION}.tar.gz

## GoogleTest

ARG GOOGLE_TEST_VERSION="1.12.0"

RUN cd /tmp \
 && git clone --branch release-${GOOGLE_TEST_VERSION} --depth 1 https://github.com/google/googletest.git \
 && cd googletest \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make -j $(nproc) \
 && make install \
 && rm -rf /tmp/googletest

# Dependencies

## Pybind11

ARG PYBIND_11_VERSION="2.10.3-1"

RUN mkdir /tmp/pybind11 \
 && cd /tmp/pybind11 \
 && wget http://ftp.us.debian.org/debian/pool/main/p/pybind11/pybind11-dev_${PYBIND_11_VERSION}_all.deb \
 && apt-get install -y ./pybind11-dev_${PYBIND_11_VERSION}_all.deb \
 && rm -rf /tmp/pybind11

## Clang-format

ARG CLANG_FORMAT_VERSION="16.0.2"

RUN mkdir -p /tmp/clang-format \
 && cd /tmp/clang-format \
 && wget --quiet https://github.com/llvm/llvm-project/releases/download/llvmorg-${CLANG_FORMAT_VERSION}/clang+llvm-${CLANG_FORMAT_VERSION}-x86_64-linux-gnu-ubuntu-22.04.tar.xz \
 && tar -xf clang+llvm-${CLANG_FORMAT_VERSION}-x86_64-linux-gnu-ubuntu-22.04.tar.xz \
 && cd clang+llvm-${CLANG_FORMAT_VERSION}-x86_64-linux-gnu-ubuntu-22.04/bin \
 && cp clang-format /usr/local/bin \
 && cp git-clang-format /usr/local/bin \
 && rm -r /tmp/clang-format

## Boost

ARG BOOST_MAJOR_VERSION="1"
ARG BOOST_MINOR_VERSION="82"
ARG BOOST_VERSION="${BOOST_MAJOR_VERSION}.${BOOST_MINOR_VERSION}.0"

RUN mkdir -p /tmp/boost \
 && cd /tmp/boost \
 && wget -O boost_${BOOST_VERSION}.tar.gz https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_0.tar.gz/download \
 && tar -xf boost_${BOOST_VERSION}.tar.gz \
 && cd boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_0 \
 && ./bootstrap.sh --with-python=/usr/local/bin/python3.10 \
 && echo "using python : 3.10 : /usr : /usr/include/python3.10m ;" >> project-config.jam \
 && ./b2 -j $(nproc) link=static cxxflags=-fPIC install \
 && ./b2 -j $(nproc) python=3.10 link=shared cxxflags=-fPIC install \
 && rm -rf /tmp/boost

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
