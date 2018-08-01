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
    python3 python3-devel \
    && dnf group install -y "Development Tools" \
    && dnf install -y gcc-c++ gdb lcov \
    && dnf clean all

## CMake [3.12.0]

RUN mkdir /tmp/cmake \
    && cd /tmp/cmake \
    && wget --quiet https://cmake.org/files/v3.12/cmake-3.12.0.tar.gz \
    && tar -xf cmake-3.12.0.tar.gz \
    && cd cmake-3.12.0 \
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
    && tar -xf boost_1_67_0.tar.gz \
    && cd boost_1_67_0 \
    && ./bootstrap.sh --with-python=/usr/bin/python3 --with-python-version=3.6 --with-python-root=/usr/lib/python3.6 \
    && echo "using python : 3.6 : /usr : /usr/include/python3.6m ;" >> project-config.jam \
    && ./b2 -j ${cpu_count} link=static cxxflags=-fPIC install \
    && rm -rf /tmp/boost

# Labels

ENV version ${version}

LABEL version="${version}"

# Execution

CMD ["/bin/bash"]

################################################################################################################################################################