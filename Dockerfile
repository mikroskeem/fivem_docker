FROM ubuntu:18.04
LABEL maintainer="Mark Vainomaa <mikroskeem@mikroskeem.eu>"

# Needed environment variables
ENV FIVEM_BUILD=1355-72908e5d2df2e5a0e0780936bd7dd85f25404686
ENV FIVEM_LICENSE_KEY=unset
ENV CFX_SERVER_DATA_GIT_URL=https://github.com/citizenfx/cfx-server-data.git

# Set up base system
RUN    DEBIAN_FRONTEND=noninteractive apt-get -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install curl git tar tzdata locales xz-utils \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && rm -rf /var/lib/apt/lists/*

# Set up fivem user
RUN    groupadd -g 1000 fivem \
    && useradd -d /home/fivem -m -u 1000 -g 1000 fivem

# Download and unpack FXServer (needs root privileges to unpack special device files)
RUN    mkdir -p /home/fivem/server \
    && curl -o /fx.tar.xz "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_BUILD}/fx.tar.xz" \
    && tar -C /home/fivem/server -xf /fx.tar.xz \
    && rm /fx.tar.xz

# Set up default user and environment
USER fivem
ENV USER=fivem HOME=/home/fivem LANG=en_US.UTF-8
WORKDIR /home/fivem

# Set up FX server data
RUN git clone --depth=1 "${CFX_SERVER_DATA_GIT_URL}" server-data

# TODO: uninstall unneeded packages after installation is done

# Workdir must be in server-data directory
WORKDIR /home/fivem/server-data

# Set up volumes
VOLUME /data

# Entry point
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
