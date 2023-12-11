FROM ubuntu:focal
LABEL author="https://github.com/aBARICHELLO/godot-ci/graphs/contributors"

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    python3 \
    python3-openssl \
    python-is-python3 \
    unzip \
    wget \
    zip \
    wine \
    && rm -rf /var/lib/apt/lists/*

ARG GODOT_VERSION="3.5.3"
ARG RELEASE_NAME="stable"
ARG TEMPLATES_ZIP="godotsteam-g353-s158-gs3213-templates.zip"

RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux_headless.64.zip \
    && wget https://github.com/CoaguCo-Industries/GodotSteam/releases/download/v3.21.3/${TEMPLATES_ZIP} \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux_headless.64.zip \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux_headless.64 /usr/local/bin/godot \
    && unzip $TEMPLATES_ZIP -d templates \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && rm -f $TEMPLATES_ZIP Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux_headless.64.zip

ENV WINEPATH="Z:\root\winebin"
RUN wget https://github.com/electron/rcedit/releases/download/v2.0.0/rcedit-x64.exe \
    && chmod u+x rcedit-x64.exe \
    && mkdir -p $HOME/winebin \
    && mv rcedit-x64.exe $HOME/winebin/rcedit.exe

ADD getbutler.sh /opt/butler/getbutler.sh
RUN bash /opt/butler/getbutler.sh
RUN /opt/butler/bin/butler -V

ENV PATH="/opt/butler/bin:${PATH}"

RUN godot -e -q
