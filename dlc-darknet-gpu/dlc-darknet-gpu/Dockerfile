# Author: Andre Telfer
# Contact: andretelfer@cmail.carleton.ca

ARG CUDA_VERSION=9.2
FROM nvidia/cuda:${CUDA_VERSION}-cudnn7-devel-ubuntu18.04

# Note: you must find the arch for your gpu from https://developer.nvidia.com/cuda-gpus#compute
ARG CUDA_VERSION
ARG CUDA_ARCH_BIN=7.5
ARG OPENCV_VERSION=3.4.10 
ARG OPENCV_INSTALL_PATH=/opencv_install

# Install dependencies
RUN apt-get update 
RUN apt-get install -y build-essential cmake unzip pkg-config wget \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libv4l-dev libxvidcore-dev libx264-dev \
    libgtk-3-dev libatlas-base-dev gfortran \
    python3-dev python3-numpy

# Download sources
RUN cd /
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip
RUN unzip opencv.zip && unzip opencv_contrib.zip
RUN mv opencv-${OPENCV_VERSION} opencv && mv opencv_contrib-${OPENCV_VERSION} opencv_contrib

# Build
RUN mkdir ${OPENCV_INSTALL_PATH}
RUN mkdir /opencv/build 
WORKDIR /opencv/build

# Options aren't well documented, so looking at the CMakeLists.txt is the best method
# OpenCV 3.4 => https://github.com/opencv/opencv/blob/3.4/CMakeLists.txt
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=${OPENCV_INSTALL_PATH} \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D INSTALL_C_EXAMPLES=OFF \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D WITH_CUDA=ON \
	-D WITH_CUDNN=ON \
	-D OPENCV_DNN_CUDA=ON \
	-D ENABLE_FAST_MATH=1 \
    -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-${CUDA_VERSION} \
	-D CUDA_FAST_MATH=1 \
	-D CUDA_ARCH_BIN=$CUDA_ARCH_BIN \
	-D WITH_CUBLAS=1 \
	-D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
	-D HAVE_opencv_python3=ON \
	-D BUILD_EXAMPLES=ON ..

RUN make -j8
RUN make install
ENV PKG_CONFIG_PATH "${OPENCV_INSTALL_PATH}/lib/pkgconfig:${PKG_CONFIG_PATH}"
RUN ldconfig

# Darknet begins here
WORKDIR /
RUN apt-get install -y git
RUN git clone https://github.com/AlexeyAB/darknet.git
RUN sed -i 's/GPU=0/GPU=1/g' /darknet/Makefile
RUN sed -i 's/CUDNN=0/CUDNN=1/g' /darknet/Makefile
RUN sed -i 's/OPENCV=0/OPENCV=1/g' /darknet/Makefile
RUN sed -i 's/LIBSO=0/LIBSO=1/g' /darknet/Makefile

WORKDIR /darknet
RUN make -j8

ENV LD_LIBRARY_PATH "${OPENCV_INSTALL_PATH}/lib:/usr/local/cuda-${CUDA_VERSION}/lib64/stubs:${PATH}"
RUN ldconfig

# Install ffmpeg
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git wget libgtk2.0-dev libxxf86vm1 ffmpeg

# Install Anaconda
WORKDIR /temp
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

# Install DLC
RUN git clone https://github.com/DeepLabCut/DeepLabCut.git
RUN conda env create -f ./DeepLabCut/conda-environments/DLC-GPU.yaml

SHELL ["conda", "run", "-n", "DLC-GPU", "/bin/bash", "-c"]
RUN python -m ipykernel install --user --name DLC-GPU --display-name "DLC-GPU"
ENV DLClight=True 
SHELL ["/bin/bash", "-c"]

# Install gcloud and gsutil
RUN apt-get install -y apt-transport-https ca-certificates gnupg curl
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update -y && apt-get install -y google-cloud-sdk
RUN apt-get install -y google-cloud-sdk-app-engine-python

# Darknet 
RUN conda create -n darknet python=3.6 numpy
SHELL ["conda", "run", "-n", "darknet", "/bin/bash", "-c"]
RUN conda install -y ipykernel 
RUN python -m ipykernel install --user --name darknet --display-name "darknet"
RUN conda install -y matplotlib cython
# RUN conda uninstall -y fontconfig
RUN cp ${OPENCV_INSTALL_PATH}/lib/python3.6/dist-packages/cv2/python-3.6/cv2.cpython-36m-x86_64-linux-gnu.so  /root/miniconda/envs/darknet/lib/python3.6/site-packages/cv2.so

RUN sed -i 's:./libdarknet.so:/darknet/libdarknet.so:g' /darknet/darknet.py
RUN cp /darknet/darknet.py /root/miniconda/envs/darknet/lib/python3.6/site-packages
RUN conda install -n darknet -y imageio

# These 2 lines fix a libglib error, however they're hacky and may break in the future
RUN mv /root/miniconda/envs/darknet/bin/../lib/libgio-2.0.so.0 /root/miniconda/envs/darknet/lib/libglib-2.0.so.0.backup
RUN apt-get install -y libglib2.0-0

# This gets rid of a cv2 error that seems to come up from custom install 
# https://github.com/opencv/opencv/issues/12625
RUN rm /root/miniconda/envs/darknet/bin/../lib/libfontconfig.so.1

# Insteall a TF1 Environment
RUN conda create -n py36-tf1 python=3.6 numpy cython
RUN conda run -n py36-tf1 pip install tensorflow-gpu==1.13.2 pandas matplotlib scikit-image scikit-learn dataclasses tables
RUN cp ${OPENCV_INSTALL_PATH}/lib/python3.6/dist-packages/cv2/python-3.6/cv2.cpython-36m-x86_64-linux-gnu.so /root/miniconda/envs/py36-tf1/lib/python3.6/site-packages/cv2.so
SHELL ["conda", "run", "-n", "py36-tf1", "/bin/bash", "-c"]
RUN conda install -y ipykernel 
RUN python -m ipykernel install --user --name "py36-tf1" --display-name "py36-tf1"

SHELL ["/bin/bash", "-c"]
COPY run.sh .
RUN chsh -s /bin/bash
ENTRYPOINT ["/bin/bash", "-c"]