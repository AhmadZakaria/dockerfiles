xhost +
docker run --privileged -it --name="latex" -e DISPLAY --net=host  bonn_va /bin/bash
