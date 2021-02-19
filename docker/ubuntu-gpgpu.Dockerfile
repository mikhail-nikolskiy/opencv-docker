ARG ver=20.04
FROM docker.io/ubuntu:${ver} AS base
LABEL Name=opencv:${ver} Version=0.0.1
USER root
WORKDIR /

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Intel distribution of GPGPU drivers: https://dgpu-docs.intel.com/
RUN apt-get update -y
RUN apt-get install -y apt-utils software-properties-common ca-certificates wget gpg-agent gnupg
RUN wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | apt-key add -
#RUN DISTRIB_CODENAME=$(cat /etc/*-release | grep DISTRIB_CODENAME | cut -d= -f2) && echo DISTRIB_CODENAME=$DISTRIB_CODENAME
RUN apt-add-repository 'deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu focal main'
RUN apt-get update -y

# build-essential
RUN apt-get install -y build-essential cmake pkg-config

# Replace intel-media-va-driver with non-free version
RUN apt-get install -y intel-media-va-driver-non-free

# OpenCV dependencies
RUN apt-get install -y libtbb-dev libjpeg-dev libpng-dev libtiff-dev libatlas-base-dev gfortran libgtk-3-dev libice-dev libsm-dev

# VAAPI
RUN apt-get install -y libva-dev vainfo

# MFX
RUN apt-get install -y libmfx-dev libmfx-tools

# OpenCL
RUN apt-get install -y intel-opencl-icd libigc1 libigc-dev libigc-tools clinfo

# FFMPEG
RUN apt-get install -y ffmpeg libavcodec-dev libavformat-dev libswscale-dev

# GStreamer
#RUN apt-get install -y libgstreamer1.0-0 libgstreamer1.0-dev \
#    libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev \
#    gstreamer1.0-plugins-base gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-plugins-good \
#    gstreamer1.0-plugins-ugly gstreamer1.0-vaapi gstreamer1.0-tools

# Build OpenCV-Debug
COPY . /root/opencv
RUN cd /root/opencv && rm -rf build && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j20

CMD ["/bin/bash"]
