# ROBO.400 course - Win11 + WSL2 + docker setup 

This repository contains instructions and docker files for setting up a ROS2 environment using Windows Subsystem for Linux 2 (WSL2) and Docker. VS code is used for this tutorial, but you can freely choose your editor / IDE for development. This course uses

- Ubuntu 22.04 Jammy
- ROS2 Humble distribution

There are a lot of guides and instructions on how to setup your local development environment (see e.g., [this repository](https://github.com/espenakk/ros2-wsl2-guide)). While this course provides one way of work, you can freely browse other options and setups, as long as you get demos done! Find ways that work for you.  

**Note: this repository and docker files are designed to be used locally, for studying purposes - not for deployment. There is a lot of information about Docker and its [secure usage](https://docs.docker.com/engine/security/), and this course does not go into details regarding that. If and when you experiment on your own, be mindful of the security risks!**

As the docker side of this course is at beta stage, please contact course personnel (Noora) for any issues. 

## Requirements 

### 1. Windows Subsystem for Linux 2 

Using Windows PowerShell,

```PowerShell
wsl --install Ubuntu-22.04 
```
You will be asked to create a username and a password. You will be using those credentials, as you would use them on Ubuntu OS. In case you need to update WSL, you can run `wsl --update`.
By the time of writing, WSL version 2.7.12.0 was used. 

After creating the credentials, you should be logged in a WSL terminal. You can recognize it by the trailing `$` letter.
You can access the terminal by writing `wsl` to Power Shell / Command Prompt. In addition, Ubuntu 22.04 terminal might have appeared to your start menu - it gives you a direct access to wsl terminal. 

```bash 
<username>@<workstation_ID>:/mnt/c/Users/<username>$
```

Update the Ubuntu environment and CA-certificates

```bash
sudo apt update && sudo apt upgrade -y
sudo apt-get install wget ca-certificates
```

Next, clone the course repository 
```bash
git clone https://github.com/NMKsas/robo400.git
```

The repository should lie in `~/robo400` directory. To get an easy access to this directory, run the following command:

```bash
echo 'cd ~/robo400' >> ~/.bashrc
```

`.bashrc` is a file ran when you open a bash terminal; `echo` command combined with `>> ~/.bashrc` adds line with `cd ~/robo400` to this file. Next time you open `wsl`, you should find yourself in the repository directory:

```bash
username@workstation_id:~/robo400$
```

### 2. Docker 

Install [Docker desktop](https://docs.docker.com/desktop/setup/install/windows-install/#installation-modes).
Use per-user installation and default options (unless you know what you are doing). 

After installation, open Docker desktop - you should find it in start menu.
Go to Settings -> Resources -> WSL integration, 
and enable integration with your default distro / Ubuntu 22.04. 

![WSL integration](/images/wsl_integration.png)

### 3. VS Code 

Install [VS Code](https://code.visualstudio.com).
In addition, install WS remote extension

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

Now, you can navigate to `~/robo400` directory and open VS Code within the workspace with command

```bash 
code .
```

For more information, see [tutorials](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-vscode) by microsoft. 


## Getting started 

Now the repository files are located at your `~/robo400` directory. First, create a directory which you will be using for development later. 

```bash
mkdir -p ros2env/src
```

You can find three different files in the directory. 

### Dockerfile 

Starting with the `Dockerfile`, 
let's review the contents in short. The first command draws a Ubuntu 22.04 image from the dockerhub

```dockerfile 
FROM ubuntu:22.04  
```

The next lines run some bash commands to install packages for e.g.,  `curl` and `python3`. In addition, `apt clean` and `rm` do some clean up. 

```dockerfile 
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    curl \
    python3-pip \
    python3-venv && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
```

The final lines will create the same directory within the container. Work directory (i.e., where you land when you open a bash terminal) is set to `/up/ros2env`

```dockerfile
RUN mkdir -p /up/ros2env/src/
WORKDIR /up/ros2env
```

For more details, see [Docker documentation](https://docs.docker.com/reference/dockerfile/). 

### Docker compose file 

Let's review some details from `docker-compose.yml`

`volumes:` binds directories. In this case, docker will bind the directory which we earlier created, `./ros2env/src`, to container's directory `/up/ros2env/src`. In practice, whatever you add and modify within the `./ros2env/src` directory, exists within the container.

**NOTE**: This workspace setup assumes, you *DO NOT* modify the files directly within the container, by e.g., using bash. If you remove the file within container, you will lose it! Always modify the files within the VS code explorer / editor of preference / windows file explorer. 

`dockerfile: Dockerfile` determines the file to be used, by default we use the `Dockerfile` provided in the repository. In case you want to use some other file and experiment, you can change the name here.

The rest are setup for enabling GUIs / visual interfaces. For more information, see [Docker documentation](https://docs.docker.com/reference/compose-file/). 


### Running the container 

Open a `wsl` terminal in your preferred command line tool. Make sure you are in `~./robo400` directory. 
Run the following command 

```bash
docker compose up
```

If you have successfully downloaded and installed everything, this command should run the container defined in `Dockerfile`, using the `docker-compose.yml` file. After running it, the terminal should include the following prints: 

```bash
 ✔ Container robo400 Created                                                                                        0.1s
Attaching to robo400
```

Now, open a 2nd `wsl` terminal of your choice. Run 

```bash 
sudo docker exec -it robo400 /bin/bash 
```

This will open an interactive terminal within the docker container. You are within a yet another linux terminal, and good to go!

```bash 
root@docker-desktop:/up/ros2env# 
```

For your convenience, this repository includes a bash script `dbash.sh` which you can use to open new terminals and avoid cumbersome writing: 

```bash
# use to open interactive terminal...
. dbash.sh 
# ...or, alternatively: 
source dbash.sh 
```

## TASK 1: Install ROS2 

Now, within the docker interactive terminal, install ROS2 using the [tutorials provided in ROS2 Humble documentation](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html). 

**Note: You can copy-paste the commands, and do not need `sudo`**

**Note: Keep the docker container running during the task.**

## TASK 2: 

Once you are finished, you can close the terminal with `Ctrl` + `c`. When the container is closed, the original environment will reset to its original state. If you re-run `docker compose up` and open an interactive terminal, you have to re-install ROS2 again! Oh no! 

Here is where Docker becomes useful. ROS community has created a docker image with the Humble installation, ready-to-use.
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

## TASK 3: 

One caveat with docker is, when you download new images they take a lot of space. It is better to free space proactively, when previously downloaded images become unused - in this case, the image we downloaded with line `FROM ubuntu:22.04`. Either use Docker Desktop or command line to remove the image (How? It is your task to find out!).
