FROM osrf/ros:humble-desktop-full

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    python3-pip \
    python3-venv \
    curl \
    git \
    # Gazebo installation
    lsb-release \
    gnupg && \
    curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    # ROS integration 
    sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    ignition-fortress \
    ros-${ROS_DISTRO}-ros-gz \
    ros-${ROS_DISTRO}-gazebo-* \
    # Turtlebot3 dependencies 
    ros-${ROS_DISTRO}-cartographer \
    ros-${ROS_DISTRO}-cartographer-ros \
    ros-${ROS_DISTRO}-navigation2 \
    ros-${ROS_DISTRO}-nav2-bringup && \
    # Cleaning the cache 
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /up/ros2env/src/
RUN mkdir -p /up/turtlebot3_ws/src/

WORKDIR /up/turtlebot3_ws

# environmental variable replacing export=GZ_VERSION command 
ENV GZ_VERSION=fortress

# adding environmental variables and ros2 sourcing to .bashrc 
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    echo "export ROS_DOMAIN_ID=30 # TURTLEBOT3" >> ~/.bashrc && \
    echo "source /usr/share/gazebo/setup.sh" >> ~/.bashrc && \
    echo "export TURTLEBOT3_MODEL=burger # or waffle, waffle_pi" >> ~/.bashrc