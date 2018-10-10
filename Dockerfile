FROM jupyter/datascience-notebook:137a295ff71b

USER root

# Setup a user
# ENV NB_USER nmt_user
# ENV NB_UID 1000
# ENV HOME /home/${NB_USER}

# RUN adduser --disabled-password \
#     --gecos "Default user" \
#     --uid ${NB_UID} \
#     ${NB_USER}

WORKDIR $HOME

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
RUN pip install --no-cache-dir notebook==5.*

# Install libsharp
RUN git clone https://github.com/Libsharp/libsharp.git $HOME/software/libsharp && \
    cd $HOME/software/libsharp && \
    autoconf -i && \
    ./configure --enable-pic && \
    make && \
    cd

# Install GSL
RUN wget ftp://ftp.gnu.org/gnu/gsl/gsl-2.5.tar.gz --passive-ftp -P $HOME/software && \
    cd $HOME/software && \
    tar -xzf gsl-2.5.tar.gz && \ 
    cd gsl-2.5 && \
    ./configure --enable-shared && \
    make && \
    make install && \
    cd

# Clone NaMaster from github
RUN git clone https://github.com/LSSTDESC/NaMaster $HOME/software/NaMaster

# Configure paths
ENV PATH=$HOME/software/libsharp/auto/bin:$PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/software/libsharp/auto/lib:/usr/local/lib
ENV LDFLAGS="-L$HOME/software/libsharp/auto/lib -L/usr/local/lib"
ENV CPPFLAGS="-I$HOME/software/libsharp/auto/include -I/usr/local/include -fopenmp"
ENV CFLAGS="-I$HOME/software/libsharp/auto/include -fopenmp"
ENV CPPFLAGS="-I$HOME/software/libsharp/auto/include -I/usr/local/include -fopenmp"

# Install NaMaster C libraries
RUN cd $HOME/software/NaMaster/ && \
    ./configure --prefix=/usr/local/ && \
    make && \
    make install && \
    make check

# Install NaMaster Python wrapper
RUN cd $HOME/software/NaMaster && \
    python setup.py install && \
    python -m unittest discover -v

# Own $HOME to NB_USER
RUN chown -R ${NB_UID} ${HOME}

USER $NB_USER

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
