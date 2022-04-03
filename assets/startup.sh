. $NVM_DIR/nvm.sh
[ -f "/config/jupyter_lab_config.py" ] || cp /home/op/config/jupyter_lab_config.py /config/jupyter_lab_config.py
jupyter-lab --config /config/jupyter_lab_config.py