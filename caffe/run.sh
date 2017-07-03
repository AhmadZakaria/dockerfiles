xhost +local:root
nvidia-docker run --rm --privileged \
                    -it \
                    --name="caffe" \
                    --net=host \
      	            -e DISPLAY \
      	            -e USER \
                    -e "http_proxy=$http_proxy"  \
                    -e "https_proxy=$https_proxy"  \
                    -v $HOME:/home/ahmad \
                    zack/caffe /bin/bash
xhost -local:root
