# Exercise 1: docker setup 

## TASK 1: Install ROS2 

Within the docker interactive terminal, install ROS2 using the [tutorials provided in ROS2 Humble documentation](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html). 

**Note: You can copy-paste the commands, and do not need `sudo`**

**Note: Keep the docker container running during the task.**

## TASK 2: Use ROS2 docker image 

Once you are finished, you can close the running container with `Ctrl` + `c`. When the container is closed, the original environment will reset to its original state. If you re-run `docker compose up` and open an interactive terminal, you have to re-install ROS2 again! Oh no! 

Here is where Docker becomes useful. ROS community supplies docker images for most of the existing distributions in [docker hub](https://hub.docker.com/_/ros), and you can use them right away! Let's try an image for Humble desktop installation. 

Change the first line in Docker file

```Dockerfile
FROM osrf/ros:humble-desktop-full
```

Re-build the dockerfile and compose up

```bash
docker compose build 
docker compose up
```

Retry the given `Talker-Listener` nodes given in the [ROS2 documentation](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html#talker-listener), using two interactive bash terminals.

## TASK 3: Remove unused images 

One caveat with docker is, when you download new images they take a lot of space. It is better to free space proactively, when previously downloaded images become unused - in this case, the image we downloaded with line `FROM ubuntu:22.04`. Either use Docker Desktop or command line to remove the image (How? It is your task to find out!).

## Exercise tips

- When working on [Colcon Tutorial](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Colcon-Tutorial.html), you have to create a `src` directory -> You can consider this step already done, you will find the folder within the docker in directory `/up/ros2env/src`. 