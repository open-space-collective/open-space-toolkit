# Apache License 2.0

FROM ubuntu:20.04 as base1

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
   ssh-client \
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

## Python

FROM base1 as base2

RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update && apt-get install -y \
   python3.8 \
   python3.8-distutils \
   python3.9 \
   python3.9-distutils \
   python3.10 \
   python3.10-distutils \
   python3.11 \
   python3.11-distutils \
   python3.12 \
   python3.12-distutils

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.8 && \
   curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9 && \
   curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10 && \
   curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 && \
   curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

FROM base2 as base3

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
   && python3.12 -m pip install --upgrade pip ipython \
   && python3.8 -m pip install --upgrade setuptools build wheel twine pytest pybind11-stubgen \
   && python3.9 -m pip install --upgrade setuptools build wheel twine pytest pybind11-stubgen\
   && python3.10 -m pip install --upgrade setuptools build wheel twine pytest pybind11-stubgen\
   && python3.11 -m pip install --upgrade setuptools build wheel twine pytest pybind11-stubgen \
   && python3.12 -m pip install --upgrade setuptools build wheel twine pytest pybind11-stubgen

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

ARG PYBIND_11_VERSION="2.12.0-1"

RUN mkdir /tmp/pybind11 \
   && cd /tmp/pybind11 \
   && wget http://ftp.us.debian.org/debian/pool/main/p/pybind11/pybind11-dev_${PYBIND_11_VERSION}_all.deb \
   && apt-get install -y ./pybind11-dev_${PYBIND_11_VERSION}_all.deb \
   && rm -rf /tmp/pybind11

## Boost

ARG BOOST_MAJOR_VERSION="1"
ARG BOOST_MINOR_VERSION="85"
ARG BOOST_VERSION="${BOOST_MAJOR_VERSION}.${BOOST_MINOR_VERSION}.0"

RUN mkdir -p /tmp/boost \
   && cd /tmp/boost \
   && wget -O boost_${BOOST_VERSION}.tar.gz https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_0.tar.gz/download \
   && tar -xf boost_${BOOST_VERSION}.tar.gz \
   && cd boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_0 \
   && ./bootstrap.sh \
   && ./b2 -j $(nproc) link=shared cxxflags=-fPIC install \
   && ./b2 -j $(nproc) link=static cxxflags=-fPIC install \
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
COPY tools/development/helpers/docs.sh /usr/bin/ostk-build-docs

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
   && chmod +x /usr/bin/ostk-debug \
   && chmod +x /usr/bin/ostk-build-docs

# Labels

ARG VERSION

ENV VERSION ${VERSION}

LABEL VERSION="${VERSION}"

# Execution

CMD ["/bin/bash"]
