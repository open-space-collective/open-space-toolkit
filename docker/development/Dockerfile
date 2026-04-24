# Apache License 2.0

ARG UV_VERSION="0.11.7"

# uv binary
FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv-binary

# Common system packages
FROM ubuntu:20.04 AS system-packages

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
   && apt-get install -y --no-install-recommends \
   # Common utilities
   ca-certificates \
   git \
   curl \
   wget \
   nano \
   htop \
   tree \
   make \
   tar \
   perl \
   # Development tools
   gcc \
   g++ \
   gdb \
   lcov \
   doxygen \
   ssh-client \
   # Build dependencies
   software-properties-common \
   zlib1g-dev \
   libssl-dev \
   && rm -rf /var/lib/apt/lists/*

# CMake builder
FROM system-packages AS cmake-builder

ARG TARGETPLATFORM
ARG CMAKE_MAJOR_VERSION="3"
ARG CMAKE_MINOR_VERSION="26"
ARG CMAKE_PATCH_VERSION="3"
ARG CMAKE_VERSION="${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}"

RUN mkdir -p /tmp/cmake \
   && mkdir -p /opt/cmake \
   && cd /tmp/cmake \
   && export PACKAGE_PLATFORM=$(if [ ${TARGETPLATFORM} = "linux/amd64" ]; then echo "x86_64"; elif [ ${TARGETPLATFORM} = "linux/arm64" ]; then echo "aarch64"; else echo "Unknown platform" && exit 1; fi;) \
   && wget --quiet https://cmake.org/files/v${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}/cmake-${CMAKE_VERSION}-linux-${PACKAGE_PLATFORM}.sh -O cmake-install.sh \
   && chmod +x /tmp/cmake/cmake-install.sh \
   && /tmp/cmake/cmake-install.sh --prefix=/opt/cmake --skip-license \
   && rm -rf /tmp/cmake

# GoogleTest builder
FROM cmake-builder AS googletest-builder

ARG GOOGLE_TEST_VERSION="1.12.0"

RUN cd /tmp \
   && git clone --branch release-${GOOGLE_TEST_VERSION} --depth 1 https://github.com/google/googletest.git \
   && cd googletest \
   && mkdir build \
   && cd build \
   && /opt/cmake/bin/cmake .. -DCMAKE_INSTALL_PREFIX=/opt/googletest -DCMAKE_BUILD_TYPE=Release \
   && make -j $(nproc) \
   && make install \
   && rm -rf /tmp/googletest

# Boost builder
FROM system-packages AS boost-builder

ARG BOOST_MAJOR_VERSION="1"
ARG BOOST_MINOR_VERSION="87"
ARG BOOST_VERSION="${BOOST_MAJOR_VERSION}.${BOOST_MINOR_VERSION}.0"

RUN mkdir -p /tmp/boost \
   && cd /tmp/boost \
   && wget -O boost_${BOOST_VERSION}.tar.gz https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_0.tar.gz/download \
   && tar -xf boost_${BOOST_VERSION}.tar.gz \
   && cd boost_${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_0 \
   && ./bootstrap.sh --prefix=/opt/boost \
   && ./b2 -j $(nproc) link=shared,static cxxflags=-fPIC \
   --with-atomic \
   --with-chrono \
   --with-date_time \
   --with-filesystem \
   --with-log \
   --with-math \
   --with-regex \
   --with-stacktrace \
   --with-system \
   --with-thread \
   install \
   && rm -rf /tmp/boost

# OpenSSL builder
FROM system-packages AS openssl-builder

ARG OPENSSL_VERSION="3.0.2"

RUN mkdir -p /tmp/openssl \
   && cd /tmp/openssl \
   && wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
   && tar -xf openssl-${OPENSSL_VERSION}.tar.gz \
   && cd openssl-${OPENSSL_VERSION} \
   && ./config --prefix=/opt/openssl --openssldir=/opt/openssl shared zlib \
   && make -j $(nproc) \
   && make install \
   && rm -rf /tmp/openssl

# Main image
FROM system-packages AS base

LABEL maintainer="lucas.bremond@gmail.com"

# Aliases

RUN alias ls='ls --color=auto' \
   && alias ll='ls -halF'

## Clang-format & Clang

ARG CLANG_VERSION="18"

RUN wget -qO /etc/apt/trusted.gpg.d/apt.llvm.org.asc https://apt.llvm.org/llvm-snapshot.gpg.key \
   && echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-${CLANG_VERSION} main" > /etc/apt/sources.list.d/llvm.list \
   && apt-get update \
   && apt-get install -y --no-install-recommends clang-format-${CLANG_VERSION} \
   && rm -rf /var/lib/apt/lists/* \
   && ln -s /usr/bin/clang-format-${CLANG_VERSION} /usr/bin/clang-format

## GCC / G++

RUN add-apt-repository ppa:ubuntu-toolchain-r/test \
   && apt-get update \
   && apt-get install -y gcc-13 g++-13 \
   && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 100 \
   && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 100 \
   && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-13 130 \
   && rm -rf /var/lib/apt/lists/*

## uv / Python
COPY --from=uv-binary /uv /uvx /bin/

ARG OSTK_PYTHON_VERSION="3.11"
ENV OSTK_PYTHON_VERSION="${OSTK_PYTHON_VERSION}"

ENV UV_PYTHON_INSTALL_DIR="/opt/uv-python"
ENV UV_LINK_MODE="copy"

RUN uv python install 3.9 \
   && uv python install 3.10 \
   && uv python install 3.11 \
   && uv python install 3.12 \
   && uv python install 3.13 \
   && chmod -R 777 ${UV_PYTHON_INSTALL_DIR} \
   && ln -sf $(uv python find ${OSTK_PYTHON_VERSION}) /usr/local/bin/python \
   && ln -sf $(uv python find ${OSTK_PYTHON_VERSION}) /usr/local/bin/python${OSTK_PYTHON_VERSION} \
   && ln -sf $(uv python find ${OSTK_PYTHON_VERSION}) /usr/local/bin/python3

ENV PYTHON_WD="/app/bindings/python"

## CMake

COPY --from=cmake-builder /opt/cmake/bin /usr/local/bin
COPY --from=cmake-builder /opt/cmake/share /usr/local/share

## GoogleTest

COPY --from=googletest-builder /opt/googletest /usr/local

## Pybind11

ARG PYBIND11_VERSION="2.13.6"

RUN mkdir -p /tmp/pybind11 \
   && cd /tmp/pybind11 \
   && wget https://github.com/pybind/pybind11/archive/refs/tags/v${PYBIND11_VERSION}.tar.gz \
   && tar -xf v${PYBIND11_VERSION}.tar.gz \
   && cd pybind11-${PYBIND11_VERSION} \
   && mkdir build \
   && cd build \
   && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DPYBIND11_TEST=OFF \
   && make install \
   && rm -rf /tmp/pybind11

## Boost

COPY --from=boost-builder /opt/boost/include /usr/local/include
COPY --from=boost-builder /opt/boost/lib /usr/local/lib

## OpenSSL

COPY --from=openssl-builder /opt/openssl /usr/local/ssl

RUN touch /etc/ld.so.conf.d/openssl.conf \
   && echo "/usr/local/ssl/lib64" >> /etc/ld.so.conf.d/openssl.conf \
   && ldconfig \
   && mv /usr/local/ssl/bin/c_rehash /usr/bin/c_rehash \
   && mv /usr/local/ssl/bin/openssl /usr/bin/openssl

# Environment

ENV LD_LIBRARY_PATH="/usr/local/lib"
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
