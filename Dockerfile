FROM circleci/node:9.8-stretch

WORKDIR ./

RUN sudo apt-get update && \
    sudo curl -O https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz && \
    sudo tar -xvf go1.8.linux-amd64.tar.gz && \
    sudo mv go /usr/local

RUN /usr/local/go/bin/go get -u github.com/tcnksm/ghr

COPY index.js package.json ./

RUN sudo yarn
