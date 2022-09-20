################################################################################################################################################################

# @project        Open Space Toolkit
# @file           docker/development/fedora/Dockerfile
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

FROM fedora:32

LABEL maintainer="lucas.bremond@gmail.com"

# Aliases

RUN alias ls='ls --color=auto' \
 && alias ll='ls -halF'

# Common tools

RUN dnf update -y \
 && dnf install -y 'dnf-command(config-manager)' \
 && dnf install -y \
    curl \
    wget \
    nano \
    htop \
    tree \
    which \
    openssl-devel \
 && dnf clean all

# Development Tools

## GCC / GDB / lcov / doxygen

RUN dnf update -y \
 && dnf install -y \
    rpm-build \
    ncurses ncurses-devel \
 && dnf group install -y "Development Tools" \
 && dnf install -y gcc-c++ gdb lcov doxygen \
 && dnf clean all

## Python [3.6, 3.7, 3.8, 3.9]

RUN dnf update -y \
 && dnf install -y \
    python36 \
    python37 \
    python38 \
    python39 \
    python3-devel \
    python3-numpy \
    python3-pip \
 && dnf clean all

RUN python3.6 -m ensurepip --default-pip \
 && python3.7 -m ensurepip --default-pip \
 && python3.7 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.9 -m ensurepip --default-pip

RUN python3.6 -m pip install --upgrade pip \
 && python3.7 -m pip install --upgrade pip \
 && python3.8 -m pip install --upgrade pip \
 && python3.9 -m pip install --upgrade pip \
 && python3 -m pip install --user --upgrade pip setuptools wheel twine pytest \
 && python3.6 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.7 -m pip install --user --upgrade setuptools wheel twine pytest \
 && python3.9 -m pip install --user --upgrade setuptools wheel twine pytest

## CMake [3.18.4]

RUN pushd /tmp > /dev/null \
 && wget --quiet https://cmake.org/files/v3.18/cmake-3.18.4.tar.gz \
 && tar -xf cmake-3.18.4.tar.gz \
 && cd cmake-3.18.4 \
 && ./bootstrap \
 && make -j $(nproc) \
 && make install \
 && popd > /dev/null \
 && rm -rf /tmp/cmake-3.18.4 /tmp/cmake-3.18.4.tar.gz

## GoogleTest [1.10.0]

RUN pushd /tmp > /dev/null \
 && git clone --branch release-1.10.0 --depth 1 https://github.com/google/googletest.git \
 && cd googletest \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make -j $(nproc) \
 && make install \
 && popd > /dev/null \
 && rm -rf /tmp/googletest

# Dependencies

## Boost [1.69.0]

RUN pushd /tmp > /dev/null \
 && wget --quiet http://sourceforge.net/projects/boost/files/boost/1.69.0/boost_1_69_0.tar.gz \
 && tar -xf boost_1_69_0.tar.gz \
 && cd boost_1_69_0 \
 && ./bootstrap.sh \
 && echo "using python : 3.8 : /usr : /usr/include/python3.8 ;" >> project-config.jam \
 && ./b2 -j $(nproc) link=static cxxflags=-fPIC install \
 && ./b2 -j $(nproc) python=3.8 link=shared cxxflags=-fPIC install \
 && popd > /dev/null \
 && rm -rf /tmp/boost_1_69_0 /tmp/boost_1_69_0.tar.gz

## Pybind11 [2.10.0-1]

RUN mkdir /tmp/pybind11 \
 && cd /tmp/pybind11 \
 && wget https://kojipkgs.fedoraproject.org/packages/pybind11/2.10.0/1.fc37/x86_64/pybind11-devel-2.10.0-1.fc37.x86_64.rpm \
 && dnf install -y ./pybind11-devel-2.10.0-1.fc37.x86_64.rpm \
 && rm -rf /tmp/pybind11 \
 && dnf clean all

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
