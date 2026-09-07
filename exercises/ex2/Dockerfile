FROM osrf/ros:humble-desktop-full

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    python3-pip \
    python3-venv \
    curl \
    lsb-release \
    gnupg && \
    curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y ignition-fortress && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /up/ros2env/src/
WORKDIR /up/ros2env