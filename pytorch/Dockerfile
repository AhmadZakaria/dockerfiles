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
# Install curl and sudo
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    sudo \
 && rm -rf /var/lib/apt/lists/*

# Use Tini as the init process with PID 1
RUN curl -Lso /tini https://github.com/krallin/tini/releases/download/v0.14.0/tini \
 && chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Create a non-root user and switch to it
# add super user with existing uid and gid
RUN groupadd ahmad -g 1000 && useradd -m -u 1000 -g 1000 ahmad && \
    echo 'ahmad ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    chown -R ahmad:ahmad /app && \
    chown -R ahmad:ahmad /opt
USER ahmad

# Install Git, bzip2, and X11 client
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    git \
    bzip2 \
    libx11-6 \
 && sudo rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN cd /opt && curl -so /opt/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.3.14-Linux-x86_64.sh \
 && chmod +x /opt/miniconda.sh \
 && /opt/miniconda.sh -b -p /opt/miniconda \
 && rm /opt/miniconda.sh

# Create a Python 3.6 environment
RUN /opt/miniconda/bin/conda install conda-build \
 && /opt/miniconda/bin/conda create -y --name pytorch-py36 \
    python=3.6.0 numpy pyyaml scipy ipython mkl \
 && /opt/miniconda/bin/conda clean -ya
ENV PATH=/opt/miniconda/envs/pytorch-py36/bin:$PATH \
    CONDA_DEFAULT_ENV=pytorch-py36 \
    CONDA_PREFIX=/opt/miniconda/envs/pytorch-py36

# CUDA 8.0-specific steps
RUN conda install -y --name pytorch-py36 -c soumith \
    magma-cuda80 \
 && conda clean -ya

# # Install PyTorch and torch-vision from Conda repo
# RUN conda install -y --name pytorch-py36 -c soumith \
#     pytorch torchvision \
#  && conda clean -ya

# Install packages for building PyTorch
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libjpeg-dev \
    libpng-dev \
 && sudo rm -rf /var/lib/apt/lists/*

# Build PyTorch from source
RUN git clone https://github.com/pytorch/pytorch.git \
 && cd pytorch \
 && git checkout 4eb448a051a1421de1dda9bd2ddfb34396eb7287 \
 && TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    python setup.py install \
 && rm -rf pytorch

# Build torch-vision from source
RUN git clone https://github.com/pytorch/vision.git \
 && cd vision \
 && git checkout 83263d8571c9cdd46f250a7986a5219ed29d19a1 \
 && python setup.py install \
 && rm -rf vision

# Install HDF5 Python bindings
RUN conda install -y --name pytorch-py36 \
    h5py \
 && conda clean -ya
RUN pip install h5py-cache

# Install Torchnet, a high-level framework for PyTorch
RUN pip install git+https://github.com/pytorch/tnt.git@master

# Install Requests, a Python library for making HTTP requests
RUN conda install -y --name pytorch-py36 requests && conda clean -ya

# Install Graphviz
RUN conda install -y --name pytorch-py36 graphviz=2.38.0 \
 && conda clean -ya
RUN pip install graphviz

# Install OpenCV3 Python bindings
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    libgtk2.0-0 \
    libcanberra-gtk-module \
 && sudo rm -rf /var/lib/apt/lists/*
RUN conda install -y --name pytorch-py36 -c menpo opencv3 \
 && conda clean -ya

# Set the default command to python3
# CMD ["python3"]

ENV QT_X11_NO_MITSHM 1

CMD ["/bin/bash"]
