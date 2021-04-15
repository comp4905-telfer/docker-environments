# Author: Andre Telfer
# Contact: andretelfer@cmail.carleton.ca

ARG CUDA_VERSION=10.2
FROM nvidia/cuda:${CUDA_VERSION}-cudnn7-devel-ubuntu18.04

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

# Install widgets for jupyter
RUN conda install -y -c conda-forge ipywidgets
RUN conda install -y -c conda-forge nodejs
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Install gcloud and gsutil
RUN apt-get install -y apt-transport-https ca-certificates gnupg curl
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update -y && apt-get install -y google-cloud-sdk
RUN apt-get install -y google-cloud-sdk-app-engine-python

# Setup environment
COPY requirements.txt .
RUN conda install -y -c conda-forge jupyterlab
RUN conda create -n py39 python=3.9 numpy cython
SHELL ["conda", "run", "-n", "py39", "/bin/bash", "-c"]
RUN pip install -r requirements.txt
RUN conda install -y ipykernel 
RUN python -m ipykernel install --user --name py39 --display-name "py39"

COPY run.sh .

RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash", "-c"]
