#!/bin/bash

DISTRIBS=${1:-ubuntu:18.04 \
  ubuntu:20.04 \
  ubuntu:20.10 \
  ubuntu:21.04 \
  ubuntu-non-free:20.04 \
  ubuntu-non-free:20.10 \
  ubuntu-non-free:21.04 \
  ubuntu-gpgpu:20.04 \
  centos-gpgpu:centos8 \
  centos-mediasdk:centos8 }

BASEDIR="$(dirname "$(readlink -fm "$0")")"
CONTEXTDIR="$(dirname "$BASEDIR")"

for dis in ${DISTRIBS}; do
  name=$(echo $dis | cut -f1 -d:)
  ver=$(echo $dis | cut -f2 -d:)
  tag="opencv:${name}-${ver}"
  echo "################# building ${tag}"

  sudo docker build -f ${BASEDIR}/${name}.Dockerfile --build-arg ver=${ver} -t ${tag} ${CONTEXTDIR} > log_build_${tag}.txt
  retVal=$?

  docker rmi $(docker images -qa -f 'dangling=true')

  if [ $retVal -eq 0 ]; then
    echo "----------------- running ${tag}"
    docker run --privileged --net=host \
      -v $OPENCV_TEST_DATA_PATH:/root/testdata \
      -e OPENCV_TEST_DATA_PATH=/root/testdata \
      ${tag} /root/opencv/build/bin/opencv_test_videoio > log_videoio_${tag}.txt 2>&1
    #tail log_videoio_${tag}.txt

    mkdir -p summary
    docker run ${tag} apt list --installed > packages.txt
    docker run ${tag} yum list installed >> packages.txt
    grep -e va-driver -e mfx -e ffmpeg -e libva -e opencl -e intel-media packages.txt > summary/${tag}.txt
    grep "acceleration =" log_videoio_${tag}.txt | grep -v NONE | sort --unique >> summary/${tag}.txt
    grep "FAILED" log_videoio_${tag}.txt >> summary/${tag}.txt
    grep "PASSED" log_videoio_${tag}.txt >> summary/${tag}.txt
    echo SUMMARY
    cat summary/${tag}.txt
  else
    tail log_build_${tag}.txt
  fi
done
