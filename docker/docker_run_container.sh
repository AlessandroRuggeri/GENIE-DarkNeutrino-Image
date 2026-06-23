#!/bin/bash

#Run the container the first time after pulling the image

docker run -e DISPLAY=host.docker.internal:0 \
  -v /Users/alessandro/Software/GENIE_Dnu_Image/Dnu_workspace:/HOME/workspace/:z \
  -it --name genie-dnu-container \
  alessandroruggeri/genie-dnu:latest

