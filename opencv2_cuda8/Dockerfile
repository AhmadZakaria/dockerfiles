FROM nvidia/cuda:8.0-devel-ubuntu16.04

ENV DEBIAN_FRONTEND noninteractive

# cach apt-get requests locally.
# Requires docker run -d -p 3142:3142 --name apt_cacher_run apt_cacher
# https://docs.docker.com/engine/examples/apt-cacher-ng/
RUN mkdir -p /etc/apt/conf.d && \
    echo 'Acquire::http { Proxy "http://172.17.0.1:3142"; };' >> /etc/apt/conf.d/01proxy

RUN apt-get update

RUN apt-get install -y \
    apt-utils \
    x11-apps \
    git \
    wget \
    vim \
    curl \
    python3-dev \
    python-dev \
    python-pip \
    python-tk  \
    build-essential \
    cmake \
    cpio \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    pkg-config \
    libjpeg8-dev \
    libtiff5-dev \
    libjasper-dev \
    libpng12-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    python-dev \
    python3-dev \
    libpython3-dev \
    libpython3.5-dev \
    libatlas-base-dev \
    gfortran \
    axel \
    python-pyqt5 \
    python-pyqt5.qtsvg \
    python-pyqt5.qtwebkit \
    unzip \
&& rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/*

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir spyder numpy scipy matplotlib ipython jupyter pandas sympy nose h5py
RUN pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install --no-cache-dir -U

ENV OPENCV_VERSION 2.4

RUN cd ~ && wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    mv opencv-${OPENCV_VERSION} opencv

RUN cd ~ && mkdir opencv/build && \
    cd opencv/build && cmake -D WITH_TBB=ON -D WITH_IPP=ON \
    -D CMAKE_BUILD_TYPE=RELEASE -D BUILD_EXAMPLES=OFF -D WITH_NVCUVID=ON \
    -D WITH_CUDA=ON -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF \
    -D BUILD_TESTS=OFF -D WITH_CSTRIPES=ON -D WITH_OPENCL=ON \
    -D ENABLE_PROFILING=ON -D BUILD_SHARED_LIBS=OFF CMAKE_INSTALL_PREFIX=/usr/local/ .. \
    && make -j4 \
    && make install \
    && cd ~ \
    && rm ${OPENCV_VERSION}.zip && rm -rf  opencv
