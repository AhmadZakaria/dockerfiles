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
              zack/pytorch:py3 /bin/bash
xhost -local:root
