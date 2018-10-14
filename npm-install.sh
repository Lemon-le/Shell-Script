#!/bin/bash

wget https://nodejs.org/dist/v8.12.0/node-v8.12.0-linux-x64.tar.xz
xz -d node-v8.12.0-linux-x64.tar.xz
tar -xf node-v8.12.0-linux-x64.tar
ln -s node-v8.12.0-linux-x64/bin/node /usr/local/bin/node
ln -s node-v8.12.0-linux-x64/bin/npm /usr/local/bin/npm
