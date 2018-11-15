################################################################################################################################################################

# @project        Libraries
# @file           tools/development/docker/Dockerfile
# @author         Lucas Brémond <lucas@loftorbital.com>
# @license        Apache License 2.0

################################################################################################################################################################

FROM fedora:27

LABEL maintainer="lucas@loftorbital.com"

# Arguments

ARG cpu_count=1

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

## Compilers

RUN dnf install -y \
    rpm-build \
    ncurses ncurses-devel \
    python3 python3-devel \
 && dnf group install -y "Development Tools" \
 && dnf install -y gcc-c++ gdb lcov \
 && dnf clean all

## Python Tools

RUN python3 -m pip install --user --upgrade setuptools wheel twine

## CMake [3.12.2]

RUN pushd /tmp > /dev/null \
 && wget --quiet https://cmake.org/files/v3.12/cmake-3.12.2.tar.gz \
 && tar -xf cmake-3.12.2.tar.gz \
 && cd cmake-3.12.2 \
 && ./bootstrap \
 && make -j ${cpu_count} \
 && make install \
 && popd > /dev/null \
 && rm -rf /tmp/cmake-3.12.2 /tmp/cmake-3.12.2.tar.gz

## GoogleTest [1.8.1]

RUN pushd /tmp > /dev/null \
 && git clone --branch release-1.8.1 --depth 1 https://github.com/google/googletest.git \
 && cd googletest \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make -j ${cpu_count} \
 && make install \
 && popd > /dev/null \
 && rm -rf /tmp/googletest

# Dependencies

## Numpy

RUN dnf update -y \
 && dnf install -y python3-numpy \
 && dnf clean all

## Boost [1.68.0]

RUN pushd /tmp > /dev/null \
 && wget --quiet http://sourceforge.net/projects/boost/files/boost/1.68.0/boost_1_68_0.tar.gz \
 && tar -xf boost_1_68_0.tar.gz \
 && cd boost_1_68_0 \
 && ./bootstrap.sh --with-python=/usr/bin/python3 --with-python-version=3.6 --with-python-root=/usr/lib/python3.6 \
 && echo "using python : 3.6 : /usr : /usr/include/python3.6m ;" >> project-config.jam \
 && ./b2 -j ${cpu_count} link=static cxxflags=-fPIC install \
 && ./b2 -j ${cpu_count} --with-python link=shared cxxflags=-fPIC install \
 && popd > /dev/null \
 && rm -rf /tmp/boost_1_68_0 /tmp/boost_1_68_0.tar.gz

# Environment

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH /usr/local/lib:${PYTHONPATH}

# Labels

ARG version

ENV version ${version}

LABEL version="${version}"

# Execution

CMD ["/bin/bash"]

################################################################################################################################################################