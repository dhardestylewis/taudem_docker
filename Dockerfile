FROM ubuntu:latest

MAINTAINER Daniel Hardesty Lewis <dhl@tacc.utexas.edu>

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ America/Chicago

RUN apt-get update && \
    apt-get install -y \
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
        python3-gdal \
        mpich \
        libmpich12 \
        libmpich-dev \
        git \
        cmake && \
    rm -rf /var/lib/apt/lists/*

## Download and build taudem
RUN wget -O /opt/TauDEM.tar.gz https://github.com/dtarb/TauDEM/archive/Develop.tar.gz && \
    tar -xvf /opt/TauDEM.tar.gz -C /opt && \
    mkdir /opt/TauDEM-Develop/src/build
WORKDIR "/opt/TauDEM-Develop/src/build"
RUN cmake .. && \
    make -j $(($(grep -c ^processor /proc/cpuinfo)-1)) && \
    make -j $(($(grep -c ^processor /proc/cpuinfo)-1)) install && \
    rm -Rf /opt/TauDEM-Develop
ENV PATH /usr/local/taudem:$PATH
