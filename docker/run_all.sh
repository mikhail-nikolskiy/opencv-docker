BASEDIR="$(dirname "$(readlink -fm "$0")")"
CONTEXTDIR="$(dirname "$BASEDIR")"

for tag in 16.04 18.04 20.04 20.10 21.04; do
  echo "################# building ${tag}"
  sudo docker build -f ${BASEDIR}/Dockerfile --build-arg tag=${tag} -t opencv:${tag} ${CONTEXTDIR} > log_build_${tag}.txt
  retVal=$?
  tail log_build_${tag}.txt

  if [ $retVal -eq 0 ]; then
    echo "----------------- running ${tag}"
    docker run --privileged --net=host \
      -v $OPENCV_TEST_DATA_PATH:/root/testdata \
      -e OPENCV_TEST_DATA_PATH=/root/testdata \
      opencv:${tag} /root/opencv/build/bin/opencv_test_videoio > log_videoio_${tag}.txt 2>&1
    grep "acceleration =" log_videoio_${tag}.txt
    tail log_videoio_${tag}.txt
  fi
done
