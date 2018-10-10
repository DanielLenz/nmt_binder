FROM python:3.6-slim

WORKDIR /home

# Setup tools to work in the container
RUN apt-get update && apt-get install -y \
    make \
    vim \
    gcc \
    g++ \
    git \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libfftw3-bin \
    libfftw3-dev \
    libfftw3-3 \
    autotools-dev \
    autoconf \
    libcfitsio-dev \
    wget \
    tar

# Install chealpix
RUN wget https://sourceforge.net/projects/healpix/files/Healpix_3.11/autotools_packages/chealpix-3.11.4.tar.gz && tar xzf chealpix-3.11.4.tar.gz && cd chealpix-3.11.4 && ./configure --enable-shared && make && make install && cd ..

# Install healpy and nose
RUN pip install nose healpy scipy

# Install libsharp
RUN git clone https://github.com/Libsharp/libsharp.git software/libsharp && \
    cd software/libsharp && \
    autoconf -i && \
    ./configure --enable-pic && \
    make && \
    cd ../..

# Install GSL
RUN wget ftp://ftp.gnu.org/gnu/gsl/gsl-2.5.tar.gz --passive-ftp -P software && \
    cd software && \
    tar -xzf gsl-2.5.tar.gz && \ 
    cd gsl-2.5 && \
    ./configure --enable-shared && \
    make && \
    make install && \
    cd ../..

# Clone NaMaster from github
RUN mkdir /home/software
RUN git clone https://github.com/LSSTDESC/NaMaster /home/software/NaMaster

# Setup the python distribution
# RUN pip install -r /home/healpy/requirements.txt
# RUN pip install scipy  # Needed for some of the tests

# Configure paths
RUN export PATH=/home/software/libsharp/auto/bin:$PATH && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/software/libsharp/auto/lib:/usr/local/lib && \
    export LDFLAGS="-L/home/software/libsharp/auto/lib -L/usr/local/lib" && \
    export CPPFLAGS="-I$/home/software/libsharp/auto/include -I/usr/local/include -fopenmp" && \
    export CFLAGS="-I/home/software/libsharp/auto/include -fopenmp" && \
    export CPPFLAGS="-I/home/software/libsharp/auto/include -I/usr/local/include -fopenmp" && \

# Install NaMaster C libraries
RUN cd /home/software/NaMaster/ && \
    ./configure --prefix=/usr/local/ && \
    make && \
    make install && \
    make check

# Install NaMaster Python wrapper
RUN python setup.py install && \
    python -m unittest discover -v

ENV HOME=/home
