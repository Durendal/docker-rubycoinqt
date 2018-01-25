[![Docker Stars](https://img.shields.io/docker/stars/durendalz/docker-rubycoinqt.svg)](https://hub.docker.com/r/durendalz/docker-rubycoinqt/)
[![Docker Pulls](https://img.shields.io/docker/pulls/durendalz/docker-rubycoinqt.svg)](https://hub.docker.com/r/durendalz/docker-rubycoinqt/)
[![ImageLayers](https://images.microbadger.com/badges/image/durendalz/docker-rubycoinqt.svg)](https://microbadger.com/images/durendalz/docker-rubycoinqt)

# rubycoinqt for Docker

Docker image that runs the Rubycoin rubycoinqt node in a container for easy deployment.

## Quickstart

Create a basic volume to store the data directory:

        $ docker volume create --name=rubycoinqt-data

To run:

        $ docker run -d \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v rubycoinqt-data:/rubycoin \
        durendalz/docker-rubycoinqt:latest

If you receive an error that the display is not available try running:

        $ xhost +local:docker

## Setup
In order to setup a Rubycoin node with the default options perform the following steps:

1. Create a volume for the rubycoin data.

        $ docker volume create --name=rubycoinqt-data

All the data the rubycoinqt service needs to work will be stored in the volume.
The volume can then be reused to restore the state of the service in case the container needs to be recreated (in case of a host restart or when upgrading the version).

2. Create and run a container with the `docker-rubycoinqt` image.

        $ docker run -d \
        --name rubycoinqt-node \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v rubycoinqt-data:/rubycoin \
        -p 5397:5397 \
        --restart unless-stopped \
         durendalz/docker-rubycoinqt

This will create a container named `rubycoinqt-node` which gets the host's port 5937 forwarded to it.
Also this container will restart in the event it crashes or the host is restarted.

3. Inspect the output of the container by using docker logs

       $ docker logs -f rubycoinqt-node

## Configuration Customization

There are 4 different ways to customize the configuration of the `rubycoinqt` daemon.

### Environment Variables to the Config Generator

If there is no `rubycoin.conf` file in the work directory (`/rubycoin`), the container creates a basic configuration file based on environmental variables.

The following are the environmental variables that can be used to change that default behavior:

- `MAX_CONNECTIONS`: When set (should be an integer), it overrides the max connections value.
- `RPC_SERVER`: If set, it enables the JSON RPC server on port 9332. If no user is given, the user will be set to `rubycoinrpc` and if no password is given a random one will be generated.
The configuration file is the first thing printed by the container and the password can be read from the logs.
- `RPC_USER`: Only used if `RPC_SERVER` is set. This states which user needs to used for the JSON RPC server.
- `RPC_PASSWORD`: Only used if `RPC_SERVER` is set. This states the password to used for the JSON RPC server.

This values can be set by adding a `-e VARIABLE=VALUE` for each of the values that want to be overriden in the `docker run` command (before the image name).

Example:

        $ docker run -d \
        --name rubycoinqt-node \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v rubycoinqt-data:/rubycoin \
        -p 5397:5397 \
        --restart unless-stopped \
        -e MAX_CONNECTIONS=25 \
        durendalz/docker-rubycoinqt

### Mounting a `rubycoin.conf` file on `/rubycoin/rubycoin.conf`

If one wants to write their own `rubycoin.conf` and have it persisted on the host but keep all the
`rubycoinqt` data inside a docker volume one can mount a file volume on `/rubycoin/rubycoin.conf` after the rubycoin data volume.

Example:

        $ docker run -d \
        --name rubycoinqt-node \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v rubycoinqt-data:/rubycoin \
        -v /etc/rubycoin.conf:/rubycoin/rubycoin.conf \
        -p 5397:5397 \
        --restart unless-stopped \
        durendalz/docker-rubycoinqt

### Have a `rubycoin.conf` in the rubycoin data directory

Instead of using a docker volume for the rubycoin data, one can mount directory on `/rubycoin` for the container to use as the rubycoin data directory.
If this directory has a `rubycoin.conf` file, this file will be used.

Just create a directory in the host machine (e.g. `/var/rubycoinqt-data`) and place your `rubycoin.conf` file in it.
Then, when creating the container in the `docker run`, instead of naming a volume to mount use the directory.

        $ docker run -d \
        --name rubycoinqt-node \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /var/rubycoinqt-data:/rubycoin \
        -p 5937:5937 \
        --restart unless-stopped \
        durendalz/docker-rubycoinqt

### Extra arguments to docker run

All the extra arguments given to `docker run` (the ones after the image name) are forwarded to the `rubycoinqt` process.
This can be used to change the behavior of the `rubycoinqt` service.

Example:

        $ docker run -d \
        --name rubycoinqt-node \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v rubycoinqt-data:/rubycoin \
        -p 5937:5937 \
        --restart unless-stopped \
        durendalz/docker-rubycoinqt \
        -timeout=10000 -proxy=10.0.0.5:3128

_Note: This doesn't prevent the default `rubycoin.conf` file to be created in the volume._
