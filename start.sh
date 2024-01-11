#!/bin/bash
eval "$(conda shell.bash hook)"

# Create the Conda environment
env_exists=1
if [ ! -d ~/.conda/envs/facefusion ]
then
  env_exists=0
  conda create -y -n facefusion python=3.10
fi 

conda deactivate
conda activate facefusion

# Get Facefusion from GitHub
if [ ! -d "facefusion" ]
then
  git clone https://github.com/facefusion/facefusion --branch 2.0.0 --single-branch
fi

# Update the installation if the parameter "update" was passed by running
# start.sh update
if [ $# -eq 1 ] && [ $1 = "update" ]
then
  cd facefusion
  git pull
  cd ..
fi

# Install the required packages if the environment needs to be freshly installed or updated 
if [ $# -eq 1 ] && [ $1 = "update" ] || [ $env_exists = 0 ]
then
  cd facefusion
  python install.py --torch cpu --onnxruntime default
  # pip install -r facefusion/requirements.txt
  pip uninstall -y opencv-python
  conda install glib=2.51.0 -y
  pip install opencv-python
  pip install opencv-python-headless
  # cd ..
  pip install pyngrok
  # conda install opencv -y
  conda install ffmpeg
fi

# Start facefusion with ngrok
if [ $# -eq 0 ]
then
  # cd ..
  python start-ngrok.py 
elif [ $1 = "reset" ]
then
  python start-ngrok.py --reset 
fi

# https://stackoverflow.com/questions/70290180/how-to-install-python-opencv-in-amazon-sagemaker
