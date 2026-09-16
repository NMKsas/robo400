# Exercise 3: TurtleBot

As in the previous exercise, we need to update `Dockerfile` to include the dependencies necessary to run TurtleBot3 simulations. 

## TASK 1: Update Dockerfile to include ROS2 dependencies

[Quick start guide for PC setup](https://docs.robotis.com/docs/systems/turtlebot3/quick_start_guide/pc_setup) includes the instructions to setup the TurtleBot environment. Start by adding the dependencies listed under the heading "Install Dependent ROS 2 Packages" to the `Dockerfile`.

## TASK 2: Create a `turtlebot3_ws` directory and bind it to a container directory 

We have used the local directory `ros2env/src` as the mounted directory: this means you can add files and packages **locally** to the directory, and the same files are available within the container. Sometimes it is cleaner to keep workspaces as separate overlays, so let's make a new local directory for TurtleBot tasks. 

Use WSL / Ubuntu terminal to create a new local directory at the root of ~/robo400 directory

```bash 
cd ~/robo400
mkdir turtlebot3_ws/src -p  # extra task: find out what -p flag does
```

See how binding was done for the `ros2env/src` directory in `Dockerfile` and `docker-compose.yml`. 
Following the example, you need to 

- Add a line that creates the `turtlebot3_ws/src` directory within the container 

- Add a line that binds the created local directory `~/robo400/turtlebot3_ws/src` to the directory within the container 

## TASK 3:  Install TurtleBot3 Packages 

[Quick start guide for PC setup](https://docs.robotis.com/docs/systems/turtlebot3/quick_start_guide/pc_setup) instructs you to install  TurtleBot3 packages. Navigate in your WSL / local terminal to the created `turtlebot3_ws/src`, and clone the necessary git repositories.

```bash 
cd ~/robo400/turtlebot3_ws/src
# Packages mentioned in the quick start guide
git clone -b humble https://github.com/ROBOTIS-GIT/DynamixelSDK.git
git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git
# This one will be needed later, when you work on simulations 
git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
```

After you have cloned the repositories, enter the container with interactive terminal (e.g., with the helper script `. dbash.sh`). Verify that your container has the new directory, and the cloned files exist within the directory. 

## TASK 4: Editing `.bashrc` file 

By now you are perhaps tired of sourcing ROS2 all the time within the container, unless you have already updated `.bashrc` file. The file consists of bash code run when new terminals are opened, for setting e.g., environmental variables. 

The [Environment Configuration](https://docs.robotis.com/docs/systems/turtlebot3/quick_start_guide/pc_setup#environment-configuration) -section instructs you to add the following lines to your ~/.bashrc file.

`echo` command prints the line between quotation marks, and `>>` writes the line directly to ~/.bashrc file: 

```bash 
echo 'export ROS_DOMAIN_ID=30 #TURTLEBOT3' >> ~/.bashrc
echo 'source /usr/share/gazebo/setup.sh' >> ~/.bashrc
echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc
source ~/.bashrc
```

Add the followig lines to your `Dockerfile`:

```dockerfile
RUN echo "export ROS_DOMAIN_ID=30 # TURTLEBOT3" >> ~/.bashrc && \
    echo "source /usr/share/gazebo/setup.sh" >> ~/.bashrc && \
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    # in addition, you can pre-define environmental variable for the used turtlebot model 
    echo "export TURTLEBOT3_MODEL=burger # or waffle, waffle_pi" >> ~/.bashrc
```

When a new Docker container is built and you enter the container, these lines are automatically run when new terminals are started. 

## TASK 5: Update `Dockerfile` to use environmental variable for ROS distribution

Instead of writing `source /opt/ros/humble/setup.bash`, the previous block of code replaced `humble` with `${ROS_DISTRO}`. 
Docker images provided by the ROS community usually define `${ROS_DISTRO}` automatically: instead of writing "humble", it is preferable to use `${ROS_DISTRO}` variable. If you later use ROS image for `jazzy` distribution, you don't have to manually change each "humble" to "jazzy" in your Dockerfile, the environmental variable does the trick for you. 

Based on this new information, update all the installations in `Dockerfile` to use `${ROS_DISTRO}` variable instead of hard-coded `humble`. 
