# ros-pytorch:noetic-base-torch2.2-cuda12.1-cudnn8-devel

FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Etc/UTC
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO noetic


# Entrypoint
RUN mkdir /entrypoint.d
RUN { \
    echo "#!/bin/bash"; \
    echo "for f in /entrypoint.d/*.sh; do [ ! -d \$f ] && source \$f; done"; \
    echo "exec \"\$@\""; \
    } > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]


# Install basic packages
RUN apt update && apt install -y --no-install-recommends \
    python3 \
    python3-dev \
    python3-pip \
    curl \
    build-essential \
    && apt clean && rm -rf /var/lib/apt/lists/*


# PyTorch
RUN pip3 install networkx==3.1
RUN pip3 install torch==2.2.1 torchvision==0.17.1 torchaudio==2.2.1 xformers==0.0.25 --index-url https://download.pytorch.org/whl/cu121


# ROS
RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt update && apt install -y --no-install-recommends \
    ros-noetic-ros-base \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep update

RUN echo "source /opt/ros/noetic/setup.bash" > /entrypoint.d/50-ros.sh


# Clean
RUN apt autoremove -y && apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV DEBIAN_FRONTEND newt
