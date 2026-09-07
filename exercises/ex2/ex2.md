# Exercise 2: Sensors

With a local Ubuntu setup, you would normally follow the given instructions: [Gazebo Fortress installation on Ubuntu](https://gazebosim.org/docs/fortress/install_ubuntu/). 

As you learnt during the first exercise, the installations done within a docker container do not persist when you shut down the container. While there are ways to "save your progress so far", this course focuses on updating the explicit `Dockerfile`s. 

## TASK 1: Understanding command line tools 

By now you should be familiar with Ubuntu's way of work to install and update packages: 

```bash 
sudo apt-get install <package_name>
sudo apt-get update 
sudo apt-get upgrade
# or
sudo apt install <package_name>
sudo apt update 
sudo apt upgrade
```

You can read about the tool differences using the unix command for system reference manuals, `man`. It is an useful command, when you want to know what commands are available for each tool, or don't know what some command does.

```bash
man apt-get
man apt 
```

Find out what is the difference between `apt update` and `apt upgrade` commands.

## TASK 2: Modify `Dockerfile` to install Gazebo to your container

The first `Dockerfile` we used was very simple, but already contains hints on how we can pre-define the necessary installations. Let's look at the second `RUN` command

```Dockerfile
RUN apt update && \ 
    DEBIAN_FRONTEND=noninteractive apt install -y \
    curl \
    python3-pip \
    python3-venv && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
```

Essentially we are running the following commands as a pre-setup:

```bash 
# updates package index
apt update

# install packages
DEBIAN_FRONTEND=noninteractive apt install -y curl python3-pip python3-venv

# removes cached packages and list of packages
# -> created container is smaller 
apt clean
rm -rf /var/lib/apt/lists/*
```

As the building phase of container is not an interactive process, you can notice `DEBIAN_FRONEND=noninteractive` and `-y` as an additional option for your regular `apt install <package_name>`. If you run the container without the options, the build will fail when the system prompts, e.g.:

```bash
After this operation, 22.5 kB of additional disk space will be used. Do you want to continue? [Y/n] 
```

In `Dockerfile` we also have to use `&&` for chaining the commands into one `RUN` instruction. `\` is used for line break.

Let's move to Gazebo installation. [Gazebo installation page](https://gazebosim.org/docs/fortress/install_ubuntu/) gives use the following commands to install the necessary packages: 

```bash
sudo apt-get update
sudo apt-get install lsb-release gnupg
```

```bash
sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get update
sudo apt-get install ignition-fortress
```

Modify the `Dockerfile` to perform the necessary installations.

## Exercise tips:

- If the world model you create on Gazebo doesn't allow you to save the file, add `.sdf` postfix to the file name
- If you cannot save the file after modifications on VS Code, it is likely due to ownership issues: the file created within the container is owned by the container user. Change the rights of the whol directory, e.g., `ros2env/src` using wsl terminal, `sudo chown -R <your_username> ~/robo400/ros2env/src`
