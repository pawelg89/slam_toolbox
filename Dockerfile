FROM ros:noetic-ros-base-focal

# USE BASH
SHELL ["/bin/bash", "-c"]

# RUN LINE BELOW TO REMOVE debconf ERRORS (MUST RUN BEFORE ANY apt-get CALLS)
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends apt-utils

# slam_toolbox
RUN mkdir -p catkin_ws/src
RUN apt-get install -y git
RUN cd catkin_ws/src && git clone -b noetic-devel https://github.com/SteveMacenski/slam_toolbox.git
RUN source /opt/ros/noetic/setup.bash \
    && cd catkin_ws \
    && rosdep update \
    && rosdep install -y -r --from-paths src --ignore-src --rosdistro=noetic -y

RUN apt install python3-catkin-tools -y
RUN source /opt/ros/noetic/setup.bash \
    && cd catkin_ws/src \
    && catkin_init_workspace \
    && cd .. \
    && catkin config --install \
    && catkin build -DCMAKE_BUILD_TYPE=Release

