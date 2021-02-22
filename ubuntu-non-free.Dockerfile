ARG ver=20.04
FROM docker.io/ubuntu:${ver} AS base
LABEL Name=opencv:${ver} Version=0.0.1
USER root
WORKDIR /

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get -y update; \
    apt-get -y -q --no-install-recommends install apt-utils software-properties-common ca-certificates wget
RUN apt-get -y install build-essential cmake pkg-config

# OpenCV dependencies
RUN apt-get -y install libtbb-dev libjpeg-dev libpng-dev libtiff-dev libatlas-base-dev gfortran libgtk-3-dev libice-dev libsm-dev

# VAAPI
RUN apt-get install -y libva-dev vainfo

# MFX (not available in 18.04)
RUN apt-get install -y libmfx-dev libmfx-tools || true

# OpenCL (Intel OpenCL not available in 18.04)
RUN apt-get install -y intel-opencl-icd libigc1 libigc-dev libigc-tools clinfo || true

# FFMPEG
RUN apt-get -y install ffmpeg libavcodec-dev libavformat-dev libswscale-dev

# GStreamer || true
RUN apt-get -y install libgstreamer1.0-0 libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly gstreamer1.0-vaapi gstreamer1.0-tools \
    || true

# Replace intel-media-va-driver with non-free version
RUN apt-get install -y intel-media-va-driver-non-free

# Build OpenCV-Debug
COPY . /root/opencv
RUN cd /root/opencv && rm -rf build && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j20

CMD ["/bin/bash"]
