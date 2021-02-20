# opencv-docker

# Video acceleration support matrix on Linux
| Linux        | Environment        | libva  | va-driver | libmfx | ffmpeg | gstreamer | cv::VideoCapture     | cv::VideoWriter     |
| ------------ | ------------------ | ------ | --------- | ------ | ------ | --------- | -------------------- | ------------------- |
| Ubuntu:18.04 | (default)          | 2.1.0  | i965      | -      | 3.4.8  | 1.14.5    | **-**                | **-**               |
| Ubuntu:20.04 | (default)          | 2.7.0  | 20.1.1    | -      | 4.2.4  | 1.16.2    | **VAAPI**            | **-**               |
|              | non-free           | 2.7.0  | 20.1.1(nf)| -      | 4.2.4  | 1.16.2    | **VAAPI**            | **VAAPI**           |
|              | gpgpu              | 2.10.0 | 21.1.0    | 21.1.0 | 4.2.4  | 1.16.2    | **VAAPI**            | **VAAPI**           |
| Ubuntu:21.04 | (default)          | 2.10.0 | 20.4.5    | 20.1.0 | 4.3.1  | 1.18.3    | **VAAPI**            | **-**               |
|              | non-free           | 2.10.0 | 20.4.5(nf)| 20.1.0 | 4.3.1  | 1.18.3    | **VAAPI, MFX**       | **MFX, VAAPI**      |
| CentOS:7     | (default)          | -      | -         | -      | -      | -         | **-**                | **-**               |
|              | multimedia         | 2.10.0 | 20.4.5    | 20.3.1 | 4.3.1  | 1.16.1    | **VAAPI, MFX**       | **MFX, VAAPI**      |
| CentOS:8     | (default)          | -      | -         | -      | -      | -         | **-**                | **-**               |
|              | multimedia         | 2.10.0 | 20.4.5    | 20.3.1 | 4.3.1  | 1.16.1    | **VAAPI, MFX**       | **MFX, VAAPI**      |
|              | gpgpu+multimedia   | 2.10.0 | 21.1.0    | 21.1.0 | 4.3.1  | 1.16.1    | **VAAPI, MFX**       | **MFX, VAAPI**      |
