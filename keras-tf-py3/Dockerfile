FROM nvidia/cuda:8.0-cudnn5-devel

ENV DEBIAN_FRONTEND noninteractive
# ENV http_proxy=http://www-cache.fkie.fraunhofer.de:3128/
# ENV https_proxy=http://www-cache.fkie.fraunhofer.de:3128/

#RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse" > /etc/apt/sources.list && \
#    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
#    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" >> /etc/apt/sources.list

# cach apt-get requests locally.
# Requires docker run -d -p 3142:3142 --name apt_cacher_run apt_cacher
# https://docs.docker.com/engine/examples/apt-cacher-ng/
RUN mkdir -p /etc/apt/conf.d && \
    echo 'Acquire::http { Proxy "http://172.17.0.1:3142"; };' >> /etc/apt/conf.d/01proxy

# https://github.com/gw0/docker-keras/blob/master/Dockerfile.py3-tf-gpu
    # install debian packages
    ENV DEBIAN_FRONTEND noninteractive
    RUN apt-get update -qq \
     && apt-get install --no-install-recommends -y \
        # install essentials
        build-essential \
        g++ \
        git \
        vim \
        # install python 3
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-virtualenv \
        python3-wheel \
        pkg-config \
        # requirements for numpy
        libopenblas-base \
        python3-numpy \
        python3-scipy \
        python3-pyqt4 \
        # requirements for keras
        python3-h5py \
        python3-yaml \
        python3-pydot \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*
     RUN pip3 --no-cache-dir install -U pip && pip install --no-cache-dir spyder

    ARG TENSORFLOW_VERSION=1.1.0
    ARG TENSORFLOW_DEVICE=gpu
    ARG TENSORFLOW_APPEND=_gpu
    RUN pip --no-cache-dir install https://storage.googleapis.com/tensorflow/linux/${TENSORFLOW_DEVICE}/tensorflow${TENSORFLOW_APPEND}-${TENSORFLOW_VERSION}-cp35-cp35m-linux_x86_64.whl

    ARG KERAS_VERSION=2.0.4
    ENV KERAS_BACKEND=tensorflow
    RUN pip --no-cache-dir install --no-dependencies git+https://github.com/fchollet/keras.git@${KERAS_VERSION}
    ENV QT_X11_NO_MITSHM 1
WORKDIR "/root"

CMD ["/bin/bash"]
