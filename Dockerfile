FROM rust:latest
COPY config /config
RUN useradd -m rust
RUN apt update && apt install -y python3 python3-pip cmake
RUN pip3 install jupyterlab
RUN cargo install evcxr_jupyter
USER 1000:1000
RUN evcxr_jupyter --install
CMD jupyter-lab --config /config/jupyter/jupyter_lab_config.py