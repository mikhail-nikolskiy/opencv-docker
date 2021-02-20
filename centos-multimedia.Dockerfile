ARG ver=centos8
FROM docker.io/centos:${ver} AS base
LABEL Name=opencv:${ver} Version=0.0.1
USER root
WORKDIR /

# epel-multimedia.repo
RUN yum -y update
RUN yum install -y epel-release
RUN yum install -y dnf-utils || true
RUN yum-config-manager --set-enabled powertools || true
RUN yum-config-manager --add-repo=https://negativo17.org/repos/epel-multimedia.repo

# Development Tools
RUN yum install -y cmake pkg-config
RUN yum groupinstall -y 'Development Tools'

# VAAPI
RUN yum install -y intel-media-driver libva-devel libva-utils
ENV LIBVA_DRIVER_NAME=iHD

# MFX
RUN yum install -y intel-mediasdk-devel

# FFMPEG
RUN yum install -y ffmpeg ffmpeg-devel

# GStreamer
RUN yum install -y gstreamer1-devel gstreamer1-plugins-base-devel gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free-devel

# cmake 3.x
RUN yum -y install cmake3 && cp -f /usr/bin/cmake3 /usr/bin/cmake || true

# Build OpenCV-Debug
COPY . /root/opencv
RUN cd /root/opencv && rm -rf build && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j20

CMD ["/bin/bash"]
