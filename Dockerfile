FROM rust:slim-bullseye as builder
RUN apt update \
 && apt install -y python3 python3-pip cmake \
 # Compile Evcxr
 && cargo install evcxr_jupyter

FROM rust:slim-bullseye as runtime
# Copy config files
COPY config /config
# Setup
RUN apt update \
 && apt install -y python3 python3-pip curl \
 && rm -rf /var/lib/apt/lists/* \
 && useradd op \
 && mkdir -p /notebooks /home/op
# Copy Evcxr
COPY --from=0 /usr/local/cargo/bin/evcxr_jupyter /home/op/evcxr_jupyter
# Setup user
RUN chown -R op /notebooks /home/op /config
USER op
WORKDIR /home/op
ENV PATH=/home/op/.local/bin:$PATH
# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
ENV NVM_DIR=/home/op/.nvm
ENV ENV=/home/op/.nvm/nvm.sh
RUN . $NVM_DIR/nvm.sh \
 # Install Node.js
 && nvm install 14.19.1 \
 # Install Jupyter Lab
 && pip3 install jupyterlab \
 # Install Evcxr
 && ./evcxr_jupyter --install \
 # Install TSLab
 && npm install -g tslab \
 && tslab install

# Launch Juputer
CMD . $NVM_DIR/nvm.sh && jupyter-lab --config /config/jupyter/default_jupyter_lab_config.py