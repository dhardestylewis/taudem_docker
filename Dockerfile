FROM dhardestylewis/tacc-ubuntulatest-mvapich2.3-psm2

MAINTAINER Daniel Hardesty Lewis <dhl@tacc.utexas.edu>

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt update -q && \
    apt install -q -y --no-install-recommends --fix-missing \
        bzip2 \
        ca-certificates \
        git \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        mercurial \
        subversion \
        wget \
        gdal-bin \
        libgdal-dev \
        libspatialindex-dev \
        mpich \
        build-essential \
        libmpich12 \
        libmpich-dev \
        cmake && \
    apt autoremove && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

CMD [ "/bin/bash" ]

ARG MINICONDA3_VERSION=py39_4.9.2
ARG MINICONDA3_SHA256=536817d1b14cb1ada88900f5be51ce0a5e042bae178b5550e62f61e223deae7c

RUN wget \
        --quiet \
        https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh \
        -O ~/miniconda.sh && \
    echo "${MINICONDA3_SHA256} ${HOME}/miniconda.sh" > ~/miniconda.sha256 && \
    if ! sha256sum --status -c ~/miniconda.sha256; then exit 1; fi && \
    mkdir -p /opt && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh ~/miniconda.sha256 && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy
ENV PATH /opt/conda/bin:$PATH

ARG TAUDEM_VERSION=Develop

RUN wget \
        -qO- \
        https://github.com/dtarb/TauDEM/archive/refs/heads/${TAUDEM_VERSION}.tar.gz | \
    tar -xzC /usr/src && \
    rm -rf /usr/src/TauDEM-${TAUDEM_VERSION}/TestSuite && \
    mkdir /usr/src/TauDEM-${TAUDEM_VERSION}/bin
WORKDIR "/usr/src/TauDEM-${TAUDEM_VERSION}/src"
RUN make
RUN ln -s /usr/src/TauDEM-${TAUDEM_VERSION} /opt/taudem
ENV PATH /opt/taudem/bin:$PATH
WORKDIR "/"

RUN apt update -q && \
    apt install -q -y --no-install-recommends --fix-missing \
        curl \
        grep \
        sed \
        dpkg && \
    TINI_VERSION=$(curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:') && \
    curl \
        -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > ~/tini.deb && \
    dpkg -i ~/tini.deb && \
    rm ~/tini.deb && \
    apt autoremove && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

