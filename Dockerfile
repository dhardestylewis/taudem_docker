FROM ubuntu:latest

MAINTAINER Daniel Hardesty Lewis <dhl@tacc.utexas.edu>

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ America/Chicago

RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    gfortran \
    python3-all-dev \
    python3-pip \
    python3-numpy \
    libblas-dev \
    liblapack-dev \
    libgeos-dev \
    libproj-dev \
    libspatialite-dev \
    libspatialite7 \
    spatialite-bin \
    libibnetdisc-dev \
    wget \
    zip \
    gdal-bin \
    gdal-data \
    libgdal26 \
    libgdal-dev \
    libgdal-doc \
    python3-gdal \
    mpich \
    mpich-doc \
    libmpich12 \
    libmpich-dev \
    git \
    cmake

## Download and build taudem
RUN git clone https://github.com/dtarb/TauDEM.git /opt/TauDEM
RUN mkdir /opt/TauDEM/src/build
WORKDIR "/opt/TauDEM/src/build"
RUN cmake ..
RUN make -j $(($(grep -c ^processor /proc/cpuinfo)-1))
RUN make -j $(($(grep -c ^processor /proc/cpuinfo)-1)) install
WORKDIR "/"
ENV PATH /usr/local/taudem:$PATH

