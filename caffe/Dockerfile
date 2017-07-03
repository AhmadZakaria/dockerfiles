FROM nvidia/cuda:8.0-cudnn6-devel
ENV DEBIAN_FRONTEND noninteractive

ENV http_proxy=http://www-cache.fkie.fraunhofer.de:3128/
ENV https_proxy=http://www-cache.fkie.fraunhofer.de:3128/

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
        python-opencv \
        cython \
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
        python-tk \
        libhdf5-dev \
        sudo && \
rm -rf /var/lib/apt/lists/*


# RUN apt-get install -y --no-install-recommends \
#             libcudnn6=$CUDNN_VERSION-1+cuda8.0 \
#             libcudnn6-dev=$CUDNN_VERSION-1+cuda8.0

# add super user with existing uid and gid
RUN groupadd ahmad -g 1000 && useradd -m -u 1000 -g 1000 ahmad && \
    echo 'ahmad ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && chown -R ahmad:ahmad /home/ahmad
USER ahmad
WORKDIR "/home/ahmad"
RUN echo 'alias sudo="sudo -HE"' >> ~/.bashrc && . ~/.bashrc

ENV CAFFE_ROOT=/opt/caffe
RUN sudo -HE mkdir -p ${CAFFE_ROOT} && sudo -HE chown ahmad:ahmad ${CAFFE_ROOT}
RUN sudo -HE pip install -U pip && \
    sudo -HE pip install --no-cache-dir -U pip setuptools && \
    sudo -HE pip install --no-cache-dir -U pip easydict
# FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
ENV CLONE_TAG=master

WORKDIR $CAFFE_ROOT
RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/BVLC/caffe.git . && \
    for req in $(cat python/requirements.txt) pydot; do sudo -HE pip install --no-cache-dir $req; done && \
    mkdir build && cd build && \
    cmake -DUSE_CUDNN=1 .. && \
    make -j"$(nproc)" && make -j"$(nproc)" pycaffe && \
    sudo -HE make install

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN sudo -HE sh -c 'echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf' && \
    sudo -HE ldconfig

ENV QT_X11_NO_MITSHM 1
WORKDIR "/home/ahmad"

CMD ["/bin/bash"]
