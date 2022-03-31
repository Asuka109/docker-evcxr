FROM rust:slim-bullseye as builder
RUN apt update \
 && apt install -y python3 python3-pip wget cmake \
 # Install Node.js
 && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
 && . /root/.bashrc \
 && nvm install 14.19.1 \
 # Compile Evcxr
 && cargo install evcxr_jupyter

FROM python:3.9-bullseye as runtime
COPY config /config
WORKDIR /home
# Copy Node.js
COPY --from=0 /root/.nvm/versions/node/v14.19.1 /nodejs
# Copy Evcxr
COPY --from=0 /usr/local/cargo/bin/evcxr_jupyter /usr/bin/evcxr_jupyter
RUN \
 # Register Node.js
 export PATH=/nodejs/bin:$PATH \
 # Install Jupyter Lab
 && pip3 install jupyterlab \
 # Install Evcxr
 && evcxr_jupyter --install \
 # Install TSLab
 && npm install -g tslab \
 && tslab install

# Boot Juputer
USER 1000:1000
CMD jupyter-lab --config /config/jupyter/jupyter_lab_config.py