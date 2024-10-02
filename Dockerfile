ARG CUDA_VERSION

# FROM nvidia/cuda:$CUDA_VERSION-devel-ubuntu18.04
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu20.04
ARG NVIDIA_VERSION

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install python3-pip libvulkan1 python3-venv vim pciutils wget git kmod vim git libglib2.0-0 libsm6 libxrender1 libxext6

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY requirements.txt scripts/install_nvidia.sh /app/
RUN pip3 install --upgrade pip

RUN pip3 install -r requirements.txt && python3 -c "import os; import ai2thor.build; ai2thor.build.Build('CloudRendering', ai2thor.build.DEFAULT_CLOUDRENDERING_COMMIT_ID, False, releases_dir=os.path.join(os.path.expanduser('~'), '.ai2thor/releases')).download()"
RUN NVIDIA_VERSION=$NVIDIA_VERSION /app/install_nvidia.sh

COPY example_agent.py ./

COPY alfred /app/alfred
RUN pip3 install -r alfred/requirements.txt

ENV ALFRED_ROOT /app/alfred

CMD ["/bin/bash"]
