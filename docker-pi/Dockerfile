FROM node:24-bookworm-slim

ARG PI_VERSION=latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash ca-certificates fd-find git ripgrep \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/*

# Pi
RUN npm install -g --ignore-scripts "@earendil-works/pi-coding-agent@${PI_VERSION}"

# User and working directory
RUN mkdir -p /workspace && chown node:node /workspace
USER node
WORKDIR /workspace

# Extensions (need to be installed in userspace)
RUN pi install npm:@pgilad/pi-vertex-anthropic
RUN pi install npm:@twogiants/pi-anthropic-vertex

ENTRYPOINT ["pi"]
