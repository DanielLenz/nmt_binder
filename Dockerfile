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
    pkg-config
    libfftw3-bin \
    libfftw3-dev \
    libfftw3-3 \
    autotools-dev \
    autoconf \
    libcfitsio3-dev

# Clone NaMaster from github
COPY . /home/healpy
RUN mkdir /home/software
RUN git clone https://github.com/LSSTDESC/NaMaster /home/software/.

# Setup the python distribution
# RUN pip install -r /home/healpy/requirements.txt
# RUN pip install scipy  # Needed for some of the tests

ENV HOME=/home
