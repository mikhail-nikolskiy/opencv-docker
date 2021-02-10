ARG tag=20.04
FROM docker.io/ubuntu:${tag} AS base
LABEL Name=opencv:${tag} Version=0.0.1
USER root
WORKDIR /

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get -y update; \
    apt-get -y -q --no-install-recommends install apt-utils software-properties-common ca-certificates wget; \
    apt-get -y install --allow-unauthenticated gnupg

RUN apt-get -y install build-essential cmake pkg-config libtbb-dev libgflags-dev
RUN apt-get -y install libjpeg-dev libpng-dev libtiff-dev
RUN apt-get -y install libatlas-base-dev gfortran
RUN apt-get -y install libgtk-3-dev libice-dev libsm-dev

# FFMPEG
RUN apt-get -y install ffmpeg libavcodec-dev libavformat-dev libswscale-dev

# GStreamer
RUN apt-get -y install libgstreamer1.0-0 gstreamer1.0-plugins-base libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-bad gstreamer1.0-libav \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools libgstreamer-plugins-bad1.0-dev

# VAAPI, MFX, OpenCL
RUN if [ ${tag} != "16.04" ]; then \
  apt-get install -y \
    libva-dev vainfo intel-media-va-driver-non-free gstreamer1.0-vaapi \
    libmfx-dev libmfx-tools \
    intel-opencl-icd libigc1 libigc-dev libigc-tools clinfo; \
fi

# Build OpenCV
COPY . /root/opencv
RUN cd /root/opencv && rm -rf build && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j20

CMD ["/bin/bash"]
