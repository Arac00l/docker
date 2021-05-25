FROM ubuntu:18.04

MAINTAINER Denis Abelyan <arac00l2@yandex.ru>

ENV HTSLIB='/usr/local/soft/htslib-1.12'
ENV SAMTOOLS='/usr/local/soft/samtools-1.12'
ENV LIBDEFLATE='/usr/local/soft/libdeflate-1.7'
ENV LIBMAUS2='/usr/local/soft/libmaus2-2.0.751-release-20200915110621'
ENV BIOBAMBAM2='/usr/local/soft/biobambam2-2.0.174-release-20200810113137'
ENV SOFT='/usr/local/soft'

# Installing the prerequisites
RUN apt-get update && \
    apt-get install -y \
    wget \
    apt-utils \
    pkg-config \
    autoconf \
    automake \
    libtool \
    make \
    gcc \
    perl \
    zlibc \
    zlib1g \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libncurses5-dev && \
    apt-get clean && apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $SOFT

# htslib-1.12 released on 17 Mar 2021
RUN wget https://github.com/samtools/htslib/releases/download/1.12/htslib-1.12.tar.bz2 && \
    tar jxf htslib-1.12.tar.bz2 && \
    rm htslib-1.12.tar.bz2 && \
    cd htslib-1.12 && \
    autoreconf -i && \
    ./configure --prefix $HTSLIB && \
    make && \
    make install

# libdeflate-1.7 released on 10 Nov 2020
RUN wget https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.7.tar.gz && \
    tar  -xvzf v1.7.tar.gz && \
    rm v1.7.tar.gz && \
    cd libdeflate-1.7 && \
    make && \
    make DESTDIR=$LIBDEFLATE install

# samtools-1.12 released on 17 Mar 2021
RUN wget https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2 && \
    tar jxf samtools-1.12.tar.bz2 && \
    rm samtools-1.12.tar.bz2 && \
    cd samtools-1.12 && \
    autoheader && \
    autoconf -Wno-syntax && \
    ./configure --prefix $SAMTOOLS && \
    make && \
    make install

# libmaus2-2.0.751 released this on 15 September 2020
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.751-release-20200915110621/libmaus2-2.0.751-release-20200915110621.tar.gz && \
    tar xvzf libmaus2-2.0.751-release-20200915110621.tar.gz && \
    rm libmaus2-2.0.751-release-20200915110621.tar.gz && \
    cd libmaus2-2.0.751-release-20200915110621 && \
    ./configure --prefix=$LIBMAUS2 && \
    make && \
    make install

# biobambam2-2.0.174 released this on 10 August 2020
RUN wget https://gitlab.com/german.tischler/biobambam2/-/archive/2.0.174-release-20200810113137/biobambam2-2.0.174-release-20200810113137.tar.gz && \
    tar xvzf biobambam2-2.0.174-release-20200810113137.tar.gz && \
    rm biobambam2-2.0.174-release-20200810113137.tar.gz && \
    cd biobambam2-2.0.174-release-20200810113137/ && \
    autoreconf -i -f && \
    ./configure --with-libmaus2=$LIBMAUS2 \
	--prefix=$BIOBAMBAM2 && \
    make install

ENV PATH=${PATH}:$HTSLIB:$SAMTOOLS:$LIBDEFLATE:$LIBMAUS2:$BIOBAMBAM2:$SOFT

CMD ["bash"]
