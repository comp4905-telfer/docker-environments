# Author: Andre Telfer
# Contact: andretelfer@cmail.carleton.ca

ARG CUDA_VERSION=10.2
ARG NOTEBOOK_TITLE_PREFIX
ARG NOTEBOOK_TITLE_POSTFIX
FROM nvidia/cuda:${CUDA_VERSION}-cudnn7-devel-ubuntu18.04

ARG NOTEBOOK_TITLE_PREFIX
ARG NOTEBOOK_TITLE_POSTFIX

ENTRYPOINT /bin/bash

# Install dependencies
RUN apt-get update 
RUN apt-get install -y build-essential cmake unzip pkg-config wget \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libv4l-dev libxvidcore-dev libx264-dev \
    libgtk-3-dev libatlas-base-dev gfortran \
    python3-dev python3-numpy git wget libgtk2.0-dev libxxf86vm1 ffmpeg

# Install Anaconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
RUN bash ~/miniconda.sh -b -p $HOME/miniconda
RUN sed -e 's|PATH="\(.*\)"|PATH="/root/miniconda/bin:\1"|g' -i /etc/environment
ENV PATH="/root/miniconda/bin:${PATH}"

# Install Jupyterlab
RUN conda install -y -c conda-forge jupyterlab

# Install jupyter widgets and tensorboard
RUN conda install -y -c conda-forge ipywidgets jupyterlab_widgets
RUN conda install -y -c conda-forge nodejs
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN conda install -y -c conda-forge tensorboard

# Install gcloud and gsutil
RUN apt-get install -y apt-transport-https ca-certificates gnupg curl
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update -y && apt-get install -y google-cloud-sdk
RUN apt-get install -y google-cloud-sdk-app-engine-python

# Code quality 
RUN pip install black

# Setup environment
COPY requirements.txt .
RUN conda create -n py39 python=3.9 numpy cython 
SHELL ["conda", "run", "-n", "py39", "/bin/bash", "-c"]
RUN pip install -r requirements.txt
RUN conda install -n py39 -y -c conda-forge ipywidgets 
RUN conda install -y ipykernel 
RUN python -m ipykernel install --user --name py39 --display-name "py39"

# Build the docker environment
RUN jupyter lab build --name=${NOTEBOOK_TITLE_PREFIX}-${NOTEBOOK_TITLE_POSTFIX}

COPY run.sh .

RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash", "-c"]
