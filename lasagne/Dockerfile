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
    cmake \
    git \
    vim \
    sudo \
    # install python 3
    python \
    python-dev \
    python-pip \
    python-setuptools \
    python-virtualenv \
    python-wheel \
    python-tk \
    pkg-config \
    # requirements for numpy
    libopenblas-base \
    python-numpy \
    python-scipy \
    python-qt4 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

 # add super user with existing uid and gid
 RUN groupadd ahmad -g 1000 && useradd -m -u 1000 -g 1000 ahmad && \
     echo 'ahmad ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && chown -R ahmad:ahmad /home/ahmad
 USER ahmad
 WORKDIR "/home/ahmad"


 RUN sudo pip --no-cache-dir install -U pip && \
     sudo pip install -U --no-cache-dir \
          Cython \
          spyder \
          matplotlib \
          pillow \
          gpustat

RUN cd ~ && git clone https://github.com/Theano/libgpuarray.git && \
    cd libgpuarray && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j4 && sudo make install && \
    cd .. && python setup.py build && sudo python setup.py install && \
    sudo ldconfig

RUN sudo pip install --upgrade --no-cache-dir https://github.com/Theano/Theano/archive/master.zip
RUN sudo pip install --upgrade --no-cache-dir https://github.com/Lasagne/Lasagne/archive/master.zip


ADD theanorc ~/.theanorc
ENV QT_X11_NO_MITSHM 1

CMD ["/bin/bash"]
