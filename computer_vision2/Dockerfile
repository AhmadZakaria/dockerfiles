FROM zack/opencv2:cuda

RUN apt-get update -qq && apt-get -y install qt5-default \
    qtcreator && \
    apt-get clean && \
rm -rf /var/lib/apt/lists/*

WORKDIR /root
