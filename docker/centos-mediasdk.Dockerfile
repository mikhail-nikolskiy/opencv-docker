ARG ver=centos8
FROM docker.io/centos:${ver} AS base
LABEL Name=opencv:${ver} Version=0.0.1
USER root
WORKDIR /

RUN dnf -y update --refresh

# Development Tools
RUN dnf install -y cmake pkg-config
RUN yum groupinstall -y 'Development Tools'

# MediaSDK
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/releases/download/intel-mediasdk-20.5.1/MediaStack.tar.gz
RUN dnf install -y wget
RUN wget -O - ${MSDK_REPO} | tar xz && \
    cd MediaStack && \
    cp -a opt/. /opt/ && \
    cp -a etc/. /opt/ && \
    ldconfig
ENV PKG_CONFIG_PATH=/opt/intel/mediasdk/lib64/pkgconfig:${PKG_CONFIG_PATH}
ENV LIBRARY_PATH=/opt/intel/mediasdk/lib64:/usr/lib:${LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/opt/intel/mediasdk/lib64/:${LD_LIBRARY_PATH}
ENV LIBVA_DRIVERS_PATH=/opt/intel/mediasdk/lib64
ENV LIBVA_DRIVER_NAME=iHD
ENV GST_VAAPI_ALL_DRIVERS=1

# FFMPEG
RUN dnf install -y epel-release dnf-utils
RUN yum-config-manager --set-enabled powertools
RUN yum-config-manager --add-repo=https://negativo17.org/repos/epel-multimedia.repo
RUN dnf install -y ffmpeg ffmpeg-devel
RUN yum install -y libva-utils

# Build OpenCV-Debug
COPY . /root/opencv
RUN cd /root/opencv && rm -rf build && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j20

CMD ["/bin/bash"]
