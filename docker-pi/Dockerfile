FROM ghcr.io/astral-sh/uv:latest AS astral_uv
FROM node:24-bookworm-slim

# System tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    fd-find \
    git \
    jq \
    ripgrep  && \
    ln -s /usr/bin/fdfind /usr/local/bin/fd && \
    rm -rf /var/lib/apt/lists/*

# Python
COPY --from=astral_uv /uv /uvx /usr/local/bin/

# Pi user and working directory
RUN userdel -r node && \
    useradd -m -s /bin/bash -u 1000 pi && \
    mkdir -p /workspace && chown pi:pi /workspace

# Switch user
USER pi
WORKDIR /home/pi

# Put global npm packages in a writable location
ENV NPM_CONFIG_PREFIX=/home/pi/.npm-global
ENV NODE_PATH=${NPM_CONFIG_PREFIX}/lib/node_modules
ENV PATH=${NPM_CONFIG_PREFIX}/bin:${PATH}

# Create required directories directories
RUN mkdir -p \
    ${NPM_CONFIG_PREFIX}/bin \
    ${NPM_CONFIG_PREFIX}/lib \
    /home/pi/.pi/agent

# Install pi globally
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# Install plugins globally (also need registering in settings.json)
RUN npm install -g --ignore-scripts \
    @twogiants/pi-anthropic-vertex \
    pi-web-access \
    @juicesharp/rpiv-ask-user-question

# Configure global models & settings
COPY --chown=pi:pi models.json /home/pi/.pi/agent/models.json
COPY --chown=pi:pi settings.json /home/pi/.pi/agent/settings.json
COPY --chown=pi:pi web-search.json /home/pi/.pi/agent/web-search.json

WORKDIR /workspace
ENTRYPOINT ["pi"]
