xhost +local:root
nvidia-docker run --rm --privileged -it \
                    -v $HOME/Documents:/root/Documents \
                    -v $HOME/Documents/DockerCache/16.04:/var/cache/apt/archives/ \
                    --name="caffe" \
                    -e DISPLAY \
                    --net=host  \
                    zack/caffe /bin/bash
xhost -local:root
