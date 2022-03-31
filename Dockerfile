FROM debian:bullseye-slim as base
RUN apt-get update \
 && apt-get install -y wget \
 && rm -rf /var/lib/apt/lists/* \
 # Install Node.js
 && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
 && . /root/.bashrc \
 && nvm install 14.19.1

FROM rust:slim-bullseye as runtime
COPY config /config
COPY --from=0 /root/.nvm/versions/node/v14.19.1 /nodejs
RUN useradd -m rust
RUN apt update \
 && apt install -y python3 python3-pip cmake \
 && rm -rf /var/lib/apt/lists/* \
 # Install Jupyter Lab
 && pip3 install jupyterlab \
 # Install Evcxr
 && cargo install evcxr_jupyter \
 && evcxr_jupyter --install \
 # Register Node.js
 && export PATH=/nodejs/bin:$PATH \
 # Install TSLab
 && npm install -g tslab \
 && tslab install
USER 1000:1000

# Boot Juputer
CMD jupyter-lab --config /config/jupyter/jupyter_lab_config.py