FROM nvidia/cuda:8.0-cudnn6-devel
ENV DEBIAN_FRONTEND noninteractive
# http://layer0.authentise.com/docker-4-useful-tips-you-may-not-know-about.html
# pick a mirror for apt-get
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get update

ENV CUDNN_VERSION 6.0.21
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

# cach apt-get requests locally.
# Requires docker run -d -p 3142:3142 --name apt_cacher_run apt_cacher
# https://docs.docker.com/engine/examples/apt-cacher-ng/
RUN mkdir -p /etc/apt/conf.d && \
    echo 'Acquire::http { Proxy "http://172.17.0.1:3142"; };' >> /etc/apt/conf.d/01proxy

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        software-properties-common \
        gcc \
        cmake \
        git \
        wget \
        vim \
        graphviz \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-scipy \
        libhdf5-dev \
        sudo && \
rm -rf /var/lib/apt/lists/*


# RUN apt-get install -y --no-install-recommends \
#             libcudnn6=$CUDNN_VERSION-1+cuda8.0 \
#             libcudnn6-dev=$CUDNN_VERSION-1+cuda8.0


ENV CAFFE_ROOT=/opt/caffe
RUN pip install -U pip && \
    pip install --no-cache-dir -U pip setuptools
# FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
ENV CLONE_TAG=master

WORKDIR $CAFFE_ROOT
RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/BVLC/caffe.git . && \
    for req in $(cat python/requirements.txt) pydot; do pip install --no-cache-dir $req; done && \
    mkdir build && cd build && \
    cmake -DUSE_CUDNN=1 .. && \
    make -j"$(nproc)" && make install

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

WORKDIR /root
