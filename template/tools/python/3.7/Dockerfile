################################################################################################################################################################

# @project        Libraries
# @file           tools/testing/python/3.7/Dockerfile
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

################################################################################################################################################################

FROM openspacecollective/library:latest as cpp-builder

COPY . /app

RUN rm -rf /app/build \
 && rm -rf /app/install \
 && mkdir /app/build \
 && mkdir /app/install

WORKDIR /app/build

# RUN cmake -DCMAKE_INSTALL_PREFIX=/app/install .. \
#  && make -j $(nproc)

# ################################################################################################################################################################

# FROM python:3.7-slim as python-installer

# COPY --from=cpp-builder /app/build/bindings/python/dist /dist

# RUN pip install /dist/*.whl

################################################################################################################################################################
