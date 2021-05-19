FROM nvidia/cuda:10.2-base-ubuntu18.04

# Install some basic utilities
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    g++ \
    ffmpeg \
    libsm6 \
    libxext6 \
    git \
    ninja-build \
    libglib2.0-0 \
    libsm6 \
    libxrender-dev \
    libxext6 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /app
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory
ENV HOME=/home/user
RUN chmod 777 /home/user

# Install Miniconda and Python 3.8
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/home/user/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-py38_4.8.3-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda install -y python==3.8.3 \
 && conda clean -ya

# CUDA 10.2-specific steps
# Install pytorch==1.8 and torchvision==0.9.0
RUN conda install -y -c conda-forge cudatoolkit=10.2 \
 && conda install -y -c pytorch pytorch==1.8.0 torchvision==0.9.0\
 && conda clean -ya


# # Use TUNA pip sources
# COPY pip.conf /etc/pip.conf

#######################
# Install MMDetection #
#######################

# Install MMCV CUDA-10.2 PyTorch-1.8.0
RUN pip install mmcv-full -f https://download.openmmlab.com/mmcv/dist/cu102/torch1.8.0/index.html

# Clone the MMDetection repository
RUN git clone https://github.com/open-mmlab/mmdetection.git
WORKDIR /app/mmdetection

# Install build requirements and then install MMDetection.
RUN pip install -r requirements/build.txt
# or "python setup.py develop"
RUN pip install -v -e .
# RUN python setup.py develop

WORKDIR /app

# Set the default command to python3
CMD ["python3"]
