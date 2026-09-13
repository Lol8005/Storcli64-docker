#!/bin/bash

git clone https://github.com/Lol8005/Storcli64-docker/
cd Storcli64-docker

sudo docker build -t local-storcli:latest .

cd ..
rm -rf Storcli64-docker

echo "alias storcli64='sudo docker run --rm -it --privileged local-storcli:latest storcli64'" >> ~/.bashrc
source ~/.bashrc

storcli64 show

echo "storcli64 alias installed."