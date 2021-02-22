ARG ver=centos8
FROM docker.io/centos:${ver} AS base
LABEL Name=opencv:${ver} Version=0.0.1
USER root
WORKDIR /

RUN yum -y update
RUN yum install -y epel-release yum-utils dnf-plugins-core
RUN yum-config-manager --set-enabled powertools || true

# Development Tools
RUN yum install -y cmake pkg-config
RUN yum groupinstall -y 'Development Tools'

# rpmfusion.org
RUN eval `cat /etc/os-release | grep CENTOS_MANTISBT_PROJECT_VERSION=` && yum install -y --nogpgcheck \
  https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$CENTOS_MANTISBT_PROJECT_VERSION.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$CENTOS_MANTISBT_PROJECT_VERSION.noarch.rpm

# FFMPEG
RUN yum install -y ffmpeg ffmpeg-devel

# GStreamer
RUN yum install -y gstreamer1-devel gstreamer1-plugins-base-devel gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugins-bad-free
# gstreamer1-plugins-bad-free-devel

# groupupdate Multimedia
RUN yum -y groupupdate Multimedia

# cmake 3.x
RUN yum -y install cmake3 && cp -f /usr/bin/cmake3 /usr/bin/cmake || true

# i965 driver
RUN yum -y install libva-intel-driver

# Build OpenCV-Debug
COPY . /root/opencv
RUN cd /root/opencv && rm -rf build && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j20

CMD ["/bin/bash"]
