# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.187.0/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version: hirsute, impish
ARG VARIANT="impish"
# FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}
FROM ubuntu:${VARIANT}

# ** [Optional] Uncomment this section to install additional packages. **
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends vlc ffmpeg mpg123 imagemagick zsh curl ca-certificates git gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup --gid 1001 vscode && \
    adduser --home /home/vscode --gecos "VSCode User" --shell /bin/zsh --uid 1001 --gid 1001 --disabled-password vscode && \
    chown -R vscode:vscode /home/vscode
