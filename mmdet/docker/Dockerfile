FROM nvidia/cuda:10.2-base-ubuntu18.04

# Install some basic utilities
RUN apt-get update && apt-get install -y --no-install-recommends\
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    g++ \
    ffmpeg \
    vim \
    libsm6 \
    libxext6 \
    git \
    ninja-build \
    libglib2.0-0 \
    libsm6 \
    libxrender-dev \
    libxext6 \
    dirmngr \
    gpg  \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver keyserver.ubuntu.com --recv-key B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Install Miniconda and Python 3.8
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/opt/miniconda/bin:$PATH
RUN curl -o /opt/miniconda.sh -SL https://repo.continuum.io/miniconda/Miniconda3-py38_4.8.3-Linux-x86_64.sh \
 && chmod +x /opt/miniconda.sh \
 && /opt/miniconda.sh -b -p /opt/miniconda \
 && rm /opt/miniconda.sh \
 && conda install -y python==3.8.3 \
 && conda clean -ya

RUN conda install -y python==3.8.3 \
 && conda clean -ya

# CUDA 10.2-specific steps
# Install pytorch==1.6.0 and torchvision==0.7.0
RUN conda install -y -c conda-forge cudatoolkit=10.2 \
 && conda install -y -c pytorch pytorch==1.6.0 torchvision==0.7.0\
 && conda clean -ya

# # Use TUNA pip sources
# COPY pip.conf /etc/pip.conf

#######################
# Install MMDetection #
#######################

# # Install MMCV CUDA-10.2 PyTorch-1.6.0
RUN pip install mmcv-full -f https://download.openmmlab.com/mmcv/dist/cu102/torch1.6.0/index.html

# Clone the MMDetection repository
RUN git clone https://github.com/open-mmlab/mmdetection.git
WORKDIR /app/mmdetection

# Install build requirements and then install MMDetection.
RUN pip install -r requirements/build.txt
# or "python setup.py develop"
RUN pip install -v -e .
# RUN python setup.py develop

# Install Python Package
RUN conda install -y pandas numpy jupyter notebook

WORKDIR /app

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

COPY ./docker-jupyter.sh /usr/local/bin/docker-jupyter.sh
RUN chmod a+x /usr/local/bin/docker-jupyter.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Set the default command 
CMD ["/usr/local/bin/docker-jupyter.sh"]
