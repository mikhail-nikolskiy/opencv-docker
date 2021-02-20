#!/bin/bash

DISTRIBS=${1:-ubuntu:18.04 \
  ubuntu:20.04 \
  ubuntu:21.04 \
  ubuntu-non-free:20.04 \
  ubuntu-non-free:21.04 \
  ubuntu-gpgpu:20.04 \
  centos:centos7 \
  centos:centos8 \
  centos-multimedia:centos7 \
  centos-multimedia:centos8 \
  centos-gpgpu-multimedia:centos8 \
  }

BASEDIR="$(dirname "$(readlink -fm "$0")")"
CONTEXTDIR="$(dirname "$BASEDIR")"

for dis in ${DISTRIBS}; do
  name=$(echo $dis | cut -f1 -d:)
  ver=$(echo $dis | cut -f2 -d:)
  tag="${name}-${ver}"
  echo "################# building ${tag}"

  sudo docker build -f ${BASEDIR}/${name}.Dockerfile --build-arg ver=${ver} -t opencv:${tag} ${CONTEXTDIR} > build_${tag}.log
  retVal=$?

  if [ $retVal -eq 0 ]; then
    echo "----------------- running ${tag}"
    sudo docker run --privileged --net=host \
      -v $OPENCV_TEST_DATA_PATH:/root/testdata \
      -e OPENCV_TEST_DATA_PATH=/root/testdata \
      opencv:${tag} /root/opencv/build/bin/opencv_test_videoio > videoio_${tag}.log 2>&1
    #tail videoio_${tag}.log

    mkdir -p summary
    sudo docker run opencv:${tag} apt list --installed > packages.txt 2>/dev/null
    sudo docker run opencv:${tag} yum list installed >> packages.txt 2>/dev/null
    grep -e va-driver -e mfx -e ffmpeg -e libva -e opencl -e intel-media -e gstreamer packages.txt > summary/${tag}.txt
    grep "acceleration =" videoio_${tag}.log | grep -v NONE | sort --unique >> summary/${tag}.txt
    grep "FAILED" videoio_${tag}.log >> summary/${tag}.txt
    grep "PASSED" videoio_${tag}.log >> summary/${tag}.txt
    echo SUMMARY
    cat summary/${tag}.txt
  else
    tail build_${tag}.log
  fi
done
