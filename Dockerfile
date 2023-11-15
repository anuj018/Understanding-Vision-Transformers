FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

ARG http_proxy
ARG https_proxy
ARG no_proxy
# ARG CUDA_VERSION
# ARG BASE_NUMBER
# ARG TORCH_VERSION

# ENV CUDADIR /usr/local/cuda
# ENV OPENBLASDIR=/usr/lib/x86_64-linux-gnu/
# ENV GPU_TARGET = Kepler Maxwell Pascal Volta
ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy
ENV PYTHON_VERSION=3.8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

# Required to build apriltags2_ethz 
env APPVEYOR_REPO_TAG_NAME=0.9.5

# ENV CUDA_VERSION=10.2


RUN apt-get update && apt-get install --no-install-recommends -y git python3.8 \
                         python3.8-dev python3.8-distutils python3-pip wget build-essential cmake \
                         libgtk-3-dev libjpeg8-dev zlib1g-dev libtiff5-dev \
                        googletest pybind11-dev libpython3-dev libopencv-dev libeigen3-dev  libeigen3-dev \
                        libpcl-dev libtbb-dev libomp-dev libgoogle-glog-dev libgflags-dev libatlas-base-dev \
                        libsuitesparse-dev vim libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade setuptools==58.2.0 wheel

# Install PyTorch 1.8 using pip
RUN pip install torch==1.8.0+cu111 torchvision==0.9.0+cu111 torchaudio==0.8.0 -f https://download.pytorch.org/whl/torch_stable.html



# Set the default Python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$PYTHON_VERSION 1

# RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz && tar -zxvf cmake-3.15.2.tar.gz && cd cmake-3.15.2 && ./bootstrap && make && make install && cd ../ && rm -rf cmake-3.15.2


RUN mkdir -p /home/tools

WORKDIR /home/tools
COPY ./requirements.txt . 
RUN python3 -m pip install -r requirements.txt

WORKDIR /workspace

CMD ["/bin/bash"]

