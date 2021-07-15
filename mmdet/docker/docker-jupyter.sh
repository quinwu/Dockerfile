#!/bin/bash

# config jupyter notebook
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