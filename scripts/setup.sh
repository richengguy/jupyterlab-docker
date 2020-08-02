#!/bin/bash

# Create the various working folders.
notebooks=${JUPYTER_WORKING_DIR:-"/home/app/notebooks"}
mkdir -p ${notebooks}
mkdir -p ${HOME}/.jupyter

cp ${HOME}/scripts/jupyter_notebook_config.py ${HOME}/.jupyter/.
