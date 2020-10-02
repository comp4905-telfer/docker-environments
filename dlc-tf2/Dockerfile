# Author: Andre Telfer
# Contact: andretelfer@cmail.carleton.ca

ARG CUDA_VERSION=10.1
FROM nvidia/cuda:${CUDA_VERSION}-cudnn7-devel-ubuntu18.04

RUN apt-get update 
RUN apt-get install -y build-essential git cmake python3-dev python3-pip wget
RUN apt-get install -y ffmpeg libsm6 libxext6 

# Install Anaconda
WORKDIR /temp
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
RUN bash ~/miniconda.sh -b -p $HOME/miniconda
RUN sed -e 's|PATH="\(.*\)"|PATH="/root/miniconda/bin:\1"|g' -i /etc/environment
ENV PATH="/root/miniconda/bin:${PATH}"

# Create test env
COPY test-env.yaml .
RUN conda env create -f test-env.yaml

# Download DLC example
WORKDIR /
RUN mkdir DLCreleases
WORKDIR DLCreleases
RUN git clone https://github.com/DeepLabCut/DeepLabCut.git

# Download DLC-core
# WORKDIR /temp
# RUN git clone https://github.com/DeepLabCut/DeepLabCut-core.git
# WORKDIR DeepLabCut-core
# RUN git checkout tf2.2alpha
# SHELL ["conda", "run", "-n", "DLC-GPU-TF2", "/bin/bash", "-c"]
# RUN python setup.py install 

WORKDIR /

RUN echo "source activate DLC-GPU-TF2" >> ~/.bashrc
RUN echo ""
SHELL ["/bin/bash", "-c"]
ENV DLClight=True
