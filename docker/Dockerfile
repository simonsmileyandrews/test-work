FROM ubuntu:16.04
#BEFORE ANDROID

# ------------------------------------------------------
# --- Environments and base directories

# Create our workspace dir


RUN mkdir /workspace
RUN export WORKSPACE="/workspace"
ENV DEBIAN_FRONTEND noninteractive
# ------------------------------------------------------
# --- Add apt repositories
# For PPAs
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java

# ------------------------------------------------------
# --- Base pre-installed tools
RUN apt-get update -qq
RUN apt-get -y install git curl wget
# Common, useful
RUN apt-get -y install python
RUN apt-get -y install build-essential
RUN apt-get -y install zip unzip

# ANDROID

ENV ANDROID_HOME /opt/android-sdk-linux
RUN dpkg --add-architecture i386
RUN apt-get update -qq
# ------------------------------------------------------
# --- Install java

RUN apt-get install -y openjdk-8-jdk libc6:i386 libstdc++6:i386 libgcc1:i386 libncurses5:i386 libz1:i386



# ------------------------------------------------------
# --- Download Android SDK tools into $ANDROID_HOME

RUN cd /opt && wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -O android-sdk-tools.zip
RUN cd /opt && unzip -q android-sdk-tools.zip
RUN mkdir -p ${ANDROID_HOME}
RUN cd /opt && mv tools/ ${ANDROID_HOME}/tools/
RUN cd /opt && rm -f android-sdk-tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin:

# ------------------------------------------------------
# --- Install required tools

# ------------------------------------------------------
# --- Install Android SDKs and other build packages

# Other tools and resources of Android SDK
#  you should only install the packages you need!
# To get a full list of available options you can use:
#  sdkmanager list
# (!!!) Only install one package at a time, as "echo y" will only work for one license!
#       If you don't do it this way you might get "Unknown response" in the logs,
#         but the android SDK tool **won't** fail, it'll just **NOT** install the package.
RUN echo y | sdkmanager platform-tools | grep 'done'

# SDKs
# Please keep these in descending order!
RUN echo y | sdkmanager "platforms;android-25" | grep 'done'
# RUN echo y | sdkmanager "platforms;android-24" | grep 'done'
# RUN echo y | sdkmanager "platforms;android-23" | grep 'done'
# RUN echo y | sdkmanager "platforms;android-22" | grep 'done'
# RUN echo y | sdkmanager "platforms;android-21" | grep 'done'
# RUN echo y | sdkmanager "platforms;android-20" | grep 'done'
# RUN echo y | sdkmanager "platforms;android-19" | grep 'done'

# build tools
# Please keep these in descending order!
RUN echo y | sdkmanager "build-tools;25.0.3" | grep 'done'
# RUN echo y | sdkmanager "build-tools;25.0.2" | grep 'done'
# RUN echo y | sdkmanager "build-tools;24.0.2" | grep 'done'
# RUN echo y | sdkmanager "build-tools;23.0.2" | grep 'done'
# RUN echo y | sdkmanager "build-tools;22.0.1" | grep 'done'
# RUN echo y | sdkmanager "build-tools;21.1.2" | grep 'done'
# RUN echo y | sdkmanager "build-tools;20.0.0" | grep 'done'
# RUN echo y | sdkmanager "build-tools;19.1.0" | grep 'done'

# Android System Images, for emulators
# Please keep these in descending order!
# Not using these as we don't need them for our build process

# RUN echo y | sdkmanager "system-images;armeabi-v7a-android-24" | grep 'done'
# RUN echo y | sdkmanager "system-images;armeabi-v7a-android-22" | grep 'done'
# RUN echo y | sdkmanager "system-images;armeabi-v7a-android-21" | grep 'done'
# RUN echo y | sdkmanager "system-images;armeabi-v7a-android-19" | grep 'done'

# Extras
RUN echo y | sdkmanager "extras;android;m2repository" | grep 'done'
RUN echo y | sdkmanager "extras;google;m2repository" | grep 'done'
RUN echo y | sdkmanager "extras;google;google_play_services" | grep 'done'

# google apis
# Please keep these in descending order!
# RUN echo y | sdkmanager "add-ons;addon-google_apis-google-23" | grep 'done'
# RUN echo y | sdkmanager "add-ons;addon-google_apis-google-22" | grep 'done'
# RUN echo y | sdkmanager "add-ons;addon-google_apis-google-21" | grep 'done'

RUN echo "SIZE OF IMAGE SO FAR:"
RUN df -h
# ------------------------------------------------------
# --- Clean apt-get packages
RUN apt-get autoclean
RUN apt-get autoremove

# ------------------------------------------------------
# --- Install Maven 3 from PPA

RUN apt-get purge maven maven2
RUN apt-get update
RUN apt-get -y install maven
RUN mvn --version

# ------------------------------------------------------
# --- Copy omscripts

# Before building this image you must have cloned omscripts to your local machine in the same folder as the Dockerfile
ENV OMSCRIPTS /omscripts
RUN mkdir /var/omscripts
COPY omscripts.git/ /var/omscripts.git
RUN git clone /var/omscripts.git "${OMSCRIPTS}"
RUN ls /var/omscripts.git

# make our su-exec folder and grab just the one commit.
RUN mkdir /home/ubuntu/ && \
cd /home/ubuntu/ && \
git clone https://github.com/ncopa/su-exec.git && \
cd su-exec && \
git checkout f85e5bde1afef399021fbc2a99c837cf851ceafa
RUN cd /home/ubuntu/su-exec && make && mv su-exec /usr/local/bin/

# ------------------------------------------------------
# --- Cleanup, Workdir and revision

# Cleaning
RUN apt-get clean
ENV WORKSPACE /workspace
WORKDIR $WORKSPACE

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]