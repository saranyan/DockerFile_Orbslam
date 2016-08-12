FROM        ubuntu:14.04
MAINTAINER  Saranyan Vigraham

#install libs first
RUN apt-key update && apt-get update
RUN apt-get install -y build-essential perl python git wget
RUN apt-get install -y libgl1-mesa-dev
RUN apt-get install -y cmake
RUN apt-get install libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev libv4l-dev
RUN apt-get install libavcodec-dev libavformat-dev libavutil-dev libpostproc-dev libswscale-dev libavdevice-dev libsdl-dev
RUN apt-get install libgtk2.0-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
RUN apt-get install libeigen3-dev nano
RUN apt-get install libblas-dev liblapack-dev
RUN apt-get install libgl1-mesa-dev libglew-dev


#install qt
RUN mkdir /inst && cd /inst && wget \
  http://download.qt.io/official_releases/qt/5.4/5.4.0/single/qt-everywhere-opensource-src-5.4.0.tar.gz
RUN mkdir /src && cd /src && tar -xvf /inst/qt-everywhere-opensource-src-5.4.0.tar.gz
RUN mv /src/qt-everywhere-opensource-src-5.4.0 /src/qt
RUN cd /src/qt && ./configure \
  -confirm-license -opensource \
  -nomake examples -nomake tests -no-compile-examples \
  -no-xcb \
  -prefix "/usr/local/Qt"
RUN cd /src/qt && make -j4 all

#install opencv
RUN cd && mkdir opencv && cd opencv && \
  wget ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/opencv-2.4.6.1.tar.gz && \
  tar zxvf opencv-2.4.6.1.tar.gz && cd opencv-2.4.6.1 && mkdir release && \
  cd release && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
  make && make install
RUN sudo echo "include /usr/local/lib" >> /etc/ld.so.conf
RUN sudo ldconfig

#install glew
RUN cd && git clone https://github.com/nigels-com/glew.git glew && cd glew && make && make install

#install pangolin
RUN cd && git clone https://github.com/stevenlovegrove/Pangolin.git && \
  cd Pangolin && mkdir build && cd build && cmake .. && make -j

#Get orb slam2
RUN cd && git clone https://github.com/raulmur/ORB_SLAM2.git ORB_SLAM2
RUN cd && cd ORB_SLAM2 && chmod +x ./build.sh && ./build.sh
