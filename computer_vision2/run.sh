xhost +local:root
nvidia-docker run --rm --privileged -it \
                    -v $HOME/Documents:/root/Documents \
                    -v $HOME/Documents/DockerCache/16.04:/var/cache/apt/archives/ \
                    --name="computer_vision_2" \
                    -e DISPLAY \
                    --net=host  \
                    zack/computer_vision_2 /bin/bash
xhost -local:root
