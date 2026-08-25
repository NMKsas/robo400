FROM ubuntu:22.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    curl \
    python3-pip \
    python3-venv && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /up/ros2env/src/
WORKDIR /up/ros2env