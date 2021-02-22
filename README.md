Collection of Ubuntu and CentOS docker files to test HW accelerated decode/encode in OpenCV VideoCapture and VideoWriter interfaces.
Plus script to build/run all or selective dockers.
The script expects OpenCV source code tree in folder one level up. Example, to run testing on OpenCV branch MY_BRANCH
```
git clone MY_BRANCH my_opencv
cd my_opencv
git clone [this-repo] opencv-docker
cd opencv-docker
./run_dockers.sh
```

## Results
Log [summary](./summary/)

Support matrix on Linux if use media libraries from standard and non-standard apt/yum repositories (no compilation from source code)
| Linux        | Package repositories | va-driver | libmfx | ffmpeg | gst reamer | cv:: VideoCapture     | cv:: VideoWriter     |
| ------------ | ------------------ | ------ | --------- | ------ | ------ | --------- | -------------------- |
| Ubuntu 18.04 | [(default apt)](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/ubuntu.Dockerfile)| i965  |  -      | 3.4.8  | 1.14.5    | **-**                | **-**               |
| Ubuntu 20.04 | [(default apt)](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/ubuntu.Dockerfile)| 20.1.1.f | -      | 4.2.4  | 1.16.2    | **VAAPI**            | **-**               |
|             | [non-free](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/ubuntu-non-free.Dockerfile) | 20.1.1  | -  | 4.2.4  | 1.16.2    | **VAAPI**            | **VAAPI**           |
|                       | [+intel.com](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/ubuntu-intel.Dockerfile) | 21.1.0 | 21.1.0 | 4.2.4  | 1.16.2    | **VAAPI**            | **VAAPI**           |
| Ubuntu 21.04 | [(default apt)](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/ubuntu.Dockerfile) | 20.4.5.f | 20.1.0 | 4.3.1  | 1.18.3    | **VAAPI**            | **-**               |
|                      | [non-free](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/ubuntu-non-free.Dockerfile) | 20.4.5 | 20.1.0 | 4.3.1  | 1.18.3    | **VAAPI,MFX**       | **MFX,VAAPI**      |
| CentOS 7     | [(default yum)](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/centos.Dockerfile) | -     | -      | -      | -         | **-**                | **-**               |
| | [+rpmfusion.com](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/centos-rpmfusion.Dockerfile) | i965 | 1.21 | 3.4.8 | 1.10.4 | **-** | **-** |
| | [+negativo17.com](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/centos-negativo17.Dockerfile) | 20.4.5 | 20.3.1 | 4.3.1 | 1.16.1 | **VAAPI,MFX** | **MFX,VAAPI** |
| CentOS 8  | [(default yum)](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/centos.Dockerfile) | - | - | - | - | **-** | **-** |
| | [+rpmfusion.com](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/centos-rpmfusion.Dockerfile) | i965 | 1.25 | 4.2.4 | 1.16.1 | **-** | **-** |
| | [+rpmfusion.com,+intel.com](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/centos-rpmfusion-intel.Dockerfile) | 21.1.0 | 21.1.0 | 4.2.4  | 1.16.1 | **VAAPI,MFX** | **VAAPI** |
| | [+negativo17.com](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/centos-negativo17.Dockerfile) | 20.4.5   | 20.3.1 | 4.3.1  | 1.16.1    | **VAAPI,MFX** | **MFX,VAAPI** |
| | [+negativo17.com,+intel.com](https://github.com/mikhail-nikolskiy/opencv-docker/blob/master/centos-negativo17-intel.Dockerfile) | 21.1.0 | 21.1.0 | 4.3.1  | 1.16.1    | **VAAPI,MFX**       | **MFX,VAAPI**      |
