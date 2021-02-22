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

# rpmfusion.org (for FFMPEG and GStreamer)
RUN dnf -y update --refresh
RUN dnf install -y epel-release dnf-utils
RUN yum-config-manager --set-enabled powertools
RUN eval `cat /etc/os-release | grep CENTOS_MANTISBT_PROJECT_VERSION=` && dnf install -y --nogpgcheck \
  https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$CENTOS_MANTISBT_PROJECT_VERSION.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$CENTOS_MANTISBT_PROJECT_VERSION.noarch.rpm
#RUN dnf install -y http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/SDL2-2.0.10-2.el8.x86_64.rpm

# FFMPEG
RUN dnf install -y ffmpeg ffmpeg-devel

# GStreamer
RUN yum install -y gstreamer1-devel gstreamer1-plugins-base-devel gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugins-bad-free
# gstreamer1-plugins-bad-free-devel

# groupupdate Multimedia
RUN dnf -y groupupdate Multimedia

# Build OpenCV-Debug
COPY . /root/opencv
RUN cd /root/opencv && rm -rf build && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j20

CMD ["/bin/bash"]
