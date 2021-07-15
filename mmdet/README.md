
# MMDetection Dockerfile README

### MMDetection version

- cuda:10.2
- pytorch:1.6.0
- torchvison:0.7.0
- mmcv:1.3.4
- mmdet:2.12.0

### File Information

- docker-entrypoint.sh

    ```bash
    #!/bin/bash

    # Add local user
    # Either use the LOCAL_USER_ID if passed in at runtime or
    # fallback

    USER_ID=${LOCAL_USER_ID:-9001}

    echo "Starting with UID : $USER_ID"
    useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
    usermod -a -G root user
    export HOME=/home/user

    exec /usr/local/bin/gosu user "$@"
    ```
    
    What we're doing here is fetching a UID from an environment variable, defaulting to 9001 if it doesn't exist, and actually creating the user "user" with the familiar useradd command while setting it's UID explicitly.
    

- docker-jupyter.sh

    ```bash
    #!/bin/bash

    # jupyter notebook config information write to /home/user/.jupyter/jupyter_notebook_config.py 
    
    # PWD = notebook
    PWD=sha1:8e41296bc947:602f563ad9c8a07d7aa5bda3e27ed8136aa39696
    jupyter notebook --generate-config
    echo "c.NotebookApp.ip = '*'" >> /home/user/.jupyter/jupyter_notebook_config.py 
    echo "c.NotebookApp.open_browser = False" >> /home/user/.jupyter/jupyter_notebook_config.py 
    echo "c.NotebookApp.password = u'${PWD}'" >> /home/user/.jupyter/jupyter_notebook_config.py 
    echo "c.NotebookApp.port = 8888" >> /home/user/.jupyter/jupyter_notebook_config.py 
    echo "c.NotebookApp.allow_root = True" >> /home/user/.jupyter/jupyter_notebook_config.py 
    echo "c.ContentsManager.root_dir = '/app'" >> /home/user/.jupyter/jupyter_notebook_config.py

    # start jupyter process
    jupyter notebook
    ```
    
    - default password: `notebook`
    - default workspace: `\app`


### How to build image

```bash 
cd docker
docker build -t {image_name:tag} .

# example:
docker build -t mmdetection-cuda10.2-torch1.6.0-mmcv1.3.4-mmdet2.12.0:v1.5 .
```


### How to run container

```bash
docker run 
    -v {host_volume_path}:{container_volume_path}  \
    -p {host_port}:{container_port}  \
    -e LOCAL_USER_ID=`id -u $USER`  \ 
    -itd {image_name}

# example:
# Map TCP port 8888 in the container to port 9986 on the Docker host.
docker run 
    -v /home/user/data:/opt/data  \
    -p 9986:8888  \
    -e LOCAL_USER_ID=`id -u $USER`  \ 
    -itd mmdetection-cuda10.2-torch1.6.0-mmcv1.3.4-mmdet2.12.0:v1.5   
```
