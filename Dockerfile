FROM alpine:latest
LABEL maintainer="Mark Vainomaa <mikroskeem@mikroskeem.eu>"

# Needed environment variables
ENV FIVEM_BUILD=2667-18d5259f60dd203b5705130491ddda4e95665171
ENV FIVEM_LICENSE_KEY=unset
ENV CFX_SERVER_DATA_GIT_URL=https://github.com/citizenfx/cfx-server-data.git

# Set up base system
RUN    apk --no-cache add curl git dumb-init

# Set up fivem user
RUN    addgroup -g 1000 fivem \
    && adduser -D -h /home/fivem -u 1000 -G fivem fivem

# Download and unpack FXServer (needs root privileges to unpack special device files)
RUN    mkdir -p /home/fivem/server \
    && curl -L -o /fx.tar.xz "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_BUILD}/fx.tar.xz" \
    && tar -C /home/fivem/server -xf /fx.tar.xz \
    && rm /fx.tar.xz

# Set up default user and environment
USER fivem
ENV USER=fivem HOME=/home/fivem LANG=en_US.UTF-8
WORKDIR /home/fivem

# Set up FX server data
RUN git clone --depth=1 "${CFX_SERVER_DATA_GIT_URL}" server-data

# Workdir must be in server-data directory
WORKDIR /home/fivem/server-data
RUN ln -s /data/resources /home/fivem/server-data/resources/'[docker]'

# Set up volumes
VOLUME /data

# Entry point
COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]
