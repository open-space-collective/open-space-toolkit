################################################################################################################################################################

# @project        Libraries
# @file           tools/python/3.6/Dockerfile
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

RUN cmake -DCMAKE_INSTALL_PREFIX=/app/install .. \
 && make -j $(nproc)
#  && make install

################################################################################################################################################################

FROM python:3.6-slim as python-installer

COPY --from=cpp-builder /app/build/bindings/python/dist /dist

RUN pip install /dist/*.whl

################################################################################################################################################################

# FROM python:3.6-slim

# LABEL maintainer="lucas.bremond@gmail.com"

# COPY --from=builder /app /app
# COPY --from=builder /app/install /app/install

# RUN pip install pytest>=5.0.1

# COPY bindings/python/requirements.txt /requirements.txt

# RUN pip install -r /requirements.txt

# ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib/python3.6/site-packages:/Library/lib
# ENV PYTHONPATH /usr/local/lib/python3.6/site-packages:/Library/lib

# COPY bindings/python/tools/python/Library /usr/local/lib/python3.6/site-packages/Library

# RUN mkdir -p /library \
#  && mkdir -p /library

# WORKDIR /Library/test

# CMD [ "pytest", "-sv" ]

################################################################################################################################################################
