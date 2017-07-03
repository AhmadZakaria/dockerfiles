# nvidia-docker run --privileged -it --rm --name keras cuda/keras
xhost +local:root
nvidia-docker run --privileged \
              -p 8888:8888 \
              -it \
              --net=host \
	            -e DISPLAY \
	            -e USER \
              -e "http_proxy=$http_proxy"  \
              -e "https_proxy=$https_proxy"  \
              -v $HOME:/home/ahmad \
              --env KERAS_BACKEND=tensorflow \
              zack/keras:tensorflow-py3 /bin/bash
# xhost +local:root
# nvidia-docker run --privileged -it \
#                     -v $HOME/Documents:/root/Documents \
#                     -v $HOME/Documents/DockerCache/16.04:/var/cache/apt/archives/ \
#                     -e "http_proxy=$http_proxy"  \
#                     -e "https_proxy=$https_proxy"  \
#                     -e "ftp_proxy=$ftp_proxy" \
#                     --name="zack-cv2_base" \
#                     -e DISPLAY \
#                     --net=host  \
#                     opencv2 /bin/bash
xhost -local:root
