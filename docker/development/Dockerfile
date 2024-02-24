# Apache License 2.0

FROM ubuntu:20.04 as root-user

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
    software-properties-common \
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
    gnupg \
 && rm -rf /var/lib/apt/lists/*

## Clang-format

RUN wget https://apt.llvm.org/llvm-snapshot.gpg.key \
 && apt-key add llvm-snapshot.gpg.key \
 && rm llvm-snapshot.gpg.key \
 && add-apt-repository 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal main' \
 && apt-get update \
 && apt-get install -y clang-format clang \
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

ARG PYTHON_3_11_VERSION="3.11.7"

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

RUN python3.8 -m pip install --upgrade pip ipython \
 && python3.9 -m pip install --upgrade pip ipython \
 && python3.10 -m pip install --upgrade pip ipython \
 && python3.11 -m pip install --upgrade pip ipython \
 && python3.8 -m pip install --upgrade setuptools build wheel twine pytest \
 && python3.9 -m pip install --upgrade setuptools build wheel twine pytest \
 && python3.10 -m pip install --upgrade setuptools build wheel twine pytest \
 && python3.11 -m pip install --upgrade setuptools build wheel twine pytest

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

## OpenSSL

ARG OPENSSL_VERSION="3.0.2"

RUN mkdir /tmp/openssl \
 && cd /tmp/openssl \
 && wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
 && tar -xvf openssl-${OPENSSL_VERSION}.tar.gz \
 && cd openssl-${OPENSSL_VERSION} \
 && ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib \
 && make \
 && make install \
 && touch /etc/ld.so.conf.d/openssl-${OPENSSL_VERSION}.conf \
 && echo "/usr/local/ssl/lib64" >> /etc/ld.so.conf.d/openssl-${OPENSSL_VERSION}.conf \
 && ldconfig \
 && mv /usr/local/ssl/bin/c_rehash /usr/bin/c_rehash \
 && mv /usr/local/ssl/bin/openssl /usr/bin/openssl \
 && rm -rf /tmp/openssl

## Black

RUN python3.11 -m pip install black black[jupyter]

# Environment

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH /usr/local/lib:${PYTHONPATH}
RUN git config --global --add safe.directory /app

# Install development helpers

COPY tools/development/helpers/build.sh /usr/bin/ostk-build
COPY tools/development/helpers/test.sh /usr/bin/ostk-test
COPY tools/development/helpers/test-python.sh /usr/bin/ostk-test-python
COPY tools/development/helpers/validate.sh /usr/bin/ostk-validate
COPY tools/development/helpers/format-cpp.sh /usr/bin/ostk-format-cpp
COPY tools/development/helpers/format-python.sh /usr/bin/ostk-format-python
COPY tools/development/helpers/check-format-cpp.sh /usr/bin/ostk-check-format-cpp
COPY tools/development/helpers/check-format-python.sh /usr/bin/ostk-check-format-python
COPY tools/development/helpers/clean.sh /usr/bin/ostk-clean
COPY tools/development/helpers/install-python.sh /usr/bin/ostk-install-python
COPY tools/development/helpers/debug.sh /usr/bin/ostk-debug

RUN chmod +x /usr/bin/ostk-build \
 && chmod +x /usr/bin/ostk-test \
 && chmod +x /usr/bin/ostk-test-python \
 && chmod +x /usr/bin/ostk-validate \
 && chmod +x /usr/bin/ostk-format-cpp \
 && chmod +x /usr/bin/ostk-format-python \
 && chmod +x /usr/bin/ostk-check-format-cpp \
 && chmod +x /usr/bin/ostk-check-format-python \
 && chmod +x /usr/bin/ostk-clean \
 && chmod +x /usr/bin/ostk-install-python \
 && chmod +x /usr/bin/ostk-debug

# Labels

ARG VERSION

ENV VERSION ${VERSION}

LABEL VERSION="${VERSION}"

# Execution

CMD ["/bin/bash"]
