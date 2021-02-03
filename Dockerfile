FROM ubuntu:latest

MAINTAINER Daniel Hardesty Lewis <dhl@tacc.utexas.edu>

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ America/Chicago
ENV TAUDEM_VERSION k
ENV TAUDEM_REPO TauDEM
ENV TAUDEM_USER dhardestylewis
ENV PATH /usr/local/taudem:$PATH

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        gcc \
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
        cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Download and build TauDEM
RUN wget \
        -O /opt/${TAUDEM_REPO}.tar.gz \
        https://github.com/${TAUDEM_USER}/${TAUDEM_REPO}/archive/${TAUDEM_VERSION}.tar.gz && \
    tar -xvf /opt/${TAUDEM_REPO}.tar.gz -C /opt && \
    mkdir /opt/${TAUDEM_REPO}-${TAUDEM_VERSION}/src/build
WORKDIR "/opt/${TAUDEM_REPO}-${TAUDEM_VERSION}/src/build"
RUN cmake .. && \
    export NCPU=$(($(grep -c ^processor /proc/cpuinfo) - 1)) && \
    make -j ${NCPU} && \
    make -j ${NCPU} install && \
    rm -Rf /opt/${TAUDEM_REPO}-${TAUDEM_VERSION}
WORKDIR "/"

