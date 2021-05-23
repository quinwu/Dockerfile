### mmdetection

- cuda:10.2
- pytorch:1.6.0
- torchvison:0.7.0
- mmcv:1.3.4
- mmdet:2.12.0


### build images

`docker build .`

### jupyter notebook

- default password: `notebook`
- default workspace: `\app`

### run container

`docker run -it -p 9986:8888 image /bin/bash`

- Map TCP port 8888 in the container to port 9986 on the Docker host.