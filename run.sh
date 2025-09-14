#!/bin/bash

# A google colab .ipynb is available here: https://drive.google.com/file/d/1pJAL8BBv49ej2Km64IZdmISEkI_tDlbY/view?usp=sharing

# Edit environment variable in Dockerfile according to the number of iterations 
# that the user wants to perform the benchmark's timing experiments with.
# Of course, regardless of the number of iterations, storage-related
# experiments should yield the same results.
# Uncomment the lines below to set the number of iterations from the reduced  
# value for simplified experiments to set it to 100 as it was in the actual 
# experiments included in the paper. This increases times but produces 
# smoother graphs.

# ITERATIONS=100 
# sed -i 's/^ENV CSD_JWT_ITERATIONS=.*$/ENV CSD_JWT_ITERATIONS=$ITERATIONS/' Dockerfile

docker build . -t csd_jwt

docker volume create csd_jwt_volume

docker run --rm -it --name csd_jwt -v csd_jwt_volume:/csd_jwt csd_jwt 

cd /tmp

VOLUME_DIR=$(docker volume inspect csd_jwt_volume | grep Mountpoint | awk '{print $2}' | tr -d "\",")

# Accessing the volume requires sudo even if user is in docker group
sudo cp $VOLUME_DIR/all_csvs.tar.gz /tmp
sudo cp $VOLUME_DIR/all_plots.tar.gz /tmp

tar xvfz all_csvs.tar.gz
tar xvfz all_plots.tar.gz 

docker image rm csd_jwt

docker volume rm csd_jwt_volume
