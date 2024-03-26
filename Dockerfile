FROM ubuntu:latest
LABEL maintainer="mail@co1in.me"

ARG TARGETOS
ARG TARGETARCH

SHELL ["/bin/bash", "-c"]

RUN set -ex; apt update \
    && apt install -y git sudo curl
RUN set -ex; useradd -m -s /bin/bash -G sudo ubuntu \
    && echo "root:ubuntu" | chpasswd \
    && echo "ubuntu:ubuntu" | chpasswd \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu
RUN set -ex; echo 'setup by ML-Env-Setup' \
    && git clone https://github.com/Co1lin/ML-Env-Setup.git \
    && cd ML-Env-Setup \
    && bash 0_basic.sh
RUN set -ex; echo "Building for ${TARGETOS}/${TARGETARCH}" \
    && curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" \
    && ls -l && bash Miniforge3-$(uname)-$(uname -m).sh -b \
    && ls -l \
    && ~/miniforge3/bin/mamba init bash \
    && ~/miniforge3/bin/mamba init zsh
RUN sudo apt-get -y install python3-pip
RUN sudo pip3 install requests

COPY ./pypi_small /home/ubuntu/pypi_small
RUN sudo mkdir -p /home/ubuntu/dist

COPY compile.sh /home/ubuntu

CMD [ "./compile.sh" ] 