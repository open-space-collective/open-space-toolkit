# Apache License 2.0

FROM ubuntu:20.04 AS base

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

## GCC / G++

RUN add-apt-repository ppa:ubuntu-toolchain-r/test \
   && apt-get update \
   && apt-get install -y gcc-13 g++-13 \
   && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 100 \
   && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 100 \
   && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-13 130

## Python

RUN add-apt-repository ppa:deadsnakes/ppa && \
   apt-get update && apt-get install -y --no-install-recommends \
   python3.9 python3.9-distutils python3.9-dev \
   python3.10 python3.10-distutils python3.10-dev \
   python3.11 python3.11-distutils python3.11-dev \
   python3.12 python3.12-dev \
   python3.13 python3.13-dev \
   python3-dev \
   && rm -rf /var/lib/apt/lists/*

## Pip

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9 \
   & curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10 \
   & curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 \
   & curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 \
   & curl -sS https://bootstrap.pypa.io/get-pip.py | python3.13 \
   & wait

## Python tools

RUN python3.9 -m pip install --upgrade pip ipython setuptools build wheel twine pytest pybind11-stubgen \
   & python3.10 -m pip install --upgrade pip ipython setuptools build wheel twine pytest pybind11-stubgen \
   & python3.11 -m pip install --upgrade pip ipython setuptools build wheel twine pytest pybind11-stubgen \
   & python3.12 -m pip install --upgrade pip ipython setuptools build wheel twine pytest pybind11-stubgen \
   & python3.13 -m pip install --upgrade pip ipython setuptools build wheel twine pytest pybind11-stubgen \
   & wait

## CMake

ARG TARGETPLATFORM
ARG CMAKE_MAJOR_VERSION="3"
ARG CMAKE_MINOR_VERSION="26"
ARG CMAKE_PATCH_VERSION="3"
ARG CMAKE_VERSION="${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}"

RUN mkdir -p /tmp/cmake \
   && cd /tmp/cmake \
   && export PACKAGE_PLATFORM=$(if [ ${TARGETPLATFORM} = "linux/amd64" ]; then echo "x86_64"; elif [ ${TARGETPLATFORM} = "linux/arm64" ]; then echo "aarch64"; else echo "Unknown platform" && exit 1; fi;) \
   && wget --quiet https://cmake.org/files/v${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}/cmake-${CMAKE_VERSION}-linux-${PACKAGE_PLATFORM}.sh -O cmake-install.sh \
   && chmod +x /tmp/cmake/cmake-install.sh \
   && /tmp/cmake/cmake-install.sh --prefix=/usr/local --skip-license \
   && rm -rf /tmp/cmake

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

ARG PYBIND_11_VERSION="2.13.6-1"

RUN mkdir /tmp/pybind11 \
   && cd /tmp/pybind11 \
   && wget http://ftp.us.debian.org/debian/pool/main/p/pybind11/pybind11-dev_${PYBIND_11_VERSION}_all.deb \
   && apt-get install -y ./pybind11-dev_${PYBIND_11_VERSION}_all.deb \
   && rm -rf /tmp/pybind11

## Boost

ARG BOOST_MAJOR_VERSION="1"
ARG BOOST_MINOR_VERSION="87"
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

ARG OSTK_PYTHON_VERSION
ENV OSTK_PYTHON_VERSION="3.11"

RUN python${OSTK_PYTHON_VERSION} -m pip install black black[jupyter]

# Environment

ENV LD_LIBRARY_PATH="/usr/local/lib"
ENV PYTHONPATH="/usr/local/lib"
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

ENV VERSION="${VERSION}"

LABEL VERSION="${VERSION}"

# Execution

CMD ["/bin/bash"]
