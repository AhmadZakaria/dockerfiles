xhost +local:root
nvidia-docker run --rm --privileged -it \
                    --net=host \
                    -e DISPLAY \
                    -e USER \
                    -e "http_proxy=$http_proxy"  \
                    -e "https_proxy=$https_proxy"  \
                    -v $HOME:/home/ahmad \
                    --name="computer_vision_2" \
                    zack/computer_vision_2 /bin/bash
xhost -local:root
