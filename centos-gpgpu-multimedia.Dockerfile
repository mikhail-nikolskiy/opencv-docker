ARG ver=centos8
FROM docker.io/centos:${ver} AS base
LABEL Name=opencv:${ver} Version=0.0.1
USER root
WORKDIR /

# Intel distribution of GPGPU drivers: https://dgpu-docs.intel.com/
RUN dnf install -y 'dnf-command(config-manager)'
RUN dnf config-manager --add-repo https://repositories.intel.com/graphics/rhel/8.1/intel-graphics.repo
RUN dnf -y update --refresh

# Development Tools
RUN dnf install -y cmake pkg-config
RUN yum groupinstall -y 'Development Tools'

# VAAPI
RUN dnf install -y intel-media libva-devel libva-utils

# MFX
RUN dnf install -y intel-mediasdk intel-mediasdk-devel

# OpenCL
RUN dnf install -y intel-opencl intel-igc-opencl-devel

# epel-multimedia.repo (for FFMPEG only)
RUN dnf -y update --refresh
RUN dnf install -y epel-release dnf-utils
RUN yum-config-manager --set-enabled powertools
RUN yum-config-manager --add-repo=https://negativo17.org/repos/epel-multimedia.repo

# FFMPEG
RUN dnf install -y ffmpeg ffmpeg-devel

# Build OpenCV-Debug
COPY . /root/opencv
RUN cd /root/opencv && rm -rf build && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j20

CMD ["/bin/bash"]
