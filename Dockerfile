FROM ubuntu:24.04
LABEL author="https://github.com/aBARICHELLO/godot-ci/graphs/contributors"

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y --no-install-recommends \
    xvfb libxcursor-dev libxinerama-dev libxi-dev \
    ca-certificates \
    git \
    git-lfs \
    python3 \
    python3-openssl \
    python-is-python3 \
    unzip \
    wget \
    zip \
    wine \
    xz-utils
RUN rm -rf /var/lib/apt/lists/*

ARG GODOT_VERSION="3.6.2"
ARG RELEASE_NAME="stable"

RUN wget https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_x11.64.zip \
    && mkdir ~/.cache \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_x11.64.zip \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_x11.64 /usr/local/bin/godot \
    && rm -f Godot_v${GODOT_VERSION}-${RELEASE_NAME}_x11.64.zip

# setup wine for rcedit
ENV WINEPATH="Z:\root\winebin"
ENV WINEPREFIX="/root/.wine"
RUN wget https://github.com/electron/rcedit/releases/download/v2.0.0/rcedit-x64.exe \
    && chmod u+x rcedit-x64.exe \
    && mkdir -p $HOME/winebin \
    && mkdir -p $HOME/.wine \
    && mv rcedit-x64.exe $HOME/winebin/rcedit.exe

# Setup godotpcktool
RUN wget https://github.com/hhyyrylainen/GodotPckTool/releases/download/v2.1/godotpcktool \
    && chmod u+x godotpcktool \
    && mv godotpcktool /usr/bin/

RUN xvfb-run godot -e -q
