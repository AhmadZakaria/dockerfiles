xhost +
docker run --privileged -it --rm --name="opencv2_cuda" -e DISPLAY --net=host  zack/opencv2:cuda /bin/bash
