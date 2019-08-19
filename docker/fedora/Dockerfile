################################################################################################################################################################

# @project        Libraries
# @file           docker/fedora/Dockerfile
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

FROM fedora:30

LABEL maintainer="lucas.bremond@gmail.com"

# Aliases

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
    which \
 && dnf clean all

# Development Tools

## GCC / GDB / lcov

RUN dnf update -y \
 && dnf install -y \
    rpm-build \
    ncurses ncurses-devel \
 && dnf group install -y "Development Tools" \
 && dnf install -y gcc-c++ gdb lcov \
 && dnf clean all

## Python [3.6, 3.7]

RUN dnf update -y \
 && dnf install -y \
    python36 python37 python3-devel python3-numpy \
 && dnf clean all

RUN python3 -m pip install --user --upgrade setuptools wheel twine

## CMake [3.15.2]

RUN pushd /tmp > /dev/null \
 && wget --quiet https://cmake.org/files/v3.15/cmake-3.15.2.tar.gz \
 && tar -xf cmake-3.15.2.tar.gz \
 && cd cmake-3.15.2 \
 && ./bootstrap \
 && make -j $(nproc) \
 && make install \
 && popd > /dev/null \
 && rm -rf /tmp/cmake-3.15.2 /tmp/cmake-3.15.2.tar.gz

## GoogleTest [1.8.1]

RUN pushd /tmp > /dev/null \
 && git clone --branch release-1.8.1 --depth 1 https://github.com/google/googletest.git \
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
 && echo "using python : 3.6 : /usr : /usr/include/python3.6m ;" >> project-config.jam \
 && echo "using python : 3.7 : /usr : /usr/include/python3.7m ;" >> project-config.jam \
 && ./b2 -j $(nproc) link=static cxxflags=-fPIC install \
 && ./b2 -j $(nproc) python=3.6,3.7 link=shared cxxflags=-fPIC install \
 && popd > /dev/null \
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
