FROM zack/opencv2:cuda

RUN apt-get update -qq && apt-get -y install qt5-default \
    qtcreator \
    sudo \
    gnuplot && \
    apt-get clean && \
rm -rf /var/lib/apt/lists/*

# add super user with existing uid and gid
RUN groupadd ahmad -g 1000 && useradd -m -u 1000 -g 1000 ahmad && \
    echo 'ahmad ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && chown -R ahmad:ahmad /home/ahmad
USER ahmad
WORKDIR "/home/ahmad"
ENV QT_X11_NO_MITSHM 1

CMD ["/bin/bash"]
