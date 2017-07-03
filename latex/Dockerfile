#Julians default dev build
FROM ubuntu:16.04

EXPOSE 8888

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    firefox \
    git \
    curl \
    vim \
    wget \
    cmake \
    locate \
    build-essential \
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
    libgtk2.0-dev \
    libatlas-base-dev \
    gfortran \
    haskell-platform \
    texlive-full \
    texmaker \
    biber \
    texlive-latex-extra \
    pandoc \
    tmux \
&& rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/*

RUN git config --global user.email "jutanke@googlemail.com"

RUN wget "https://github.com/atom/atom/releases/download/v1.16.0/atom-amd64.deb"
RUN apt-get install -y libnotify4 \
    libnss3 gvfs-bin xdg-utils htop \
    && dpkg --install atom-amd64.deb

CMD ["/bin/bash"]
