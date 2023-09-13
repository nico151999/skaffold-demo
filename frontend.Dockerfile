ARG USER_ID=1000
ARG GROUP_ID=1000
ARG PNPM_VERSION=8.7.5

FROM node:lts-alpine AS builder
ARG USER_ID
ARG GROUP_ID
ARG PNPM_VERSION

RUN apk add --no-cache curl && \
    curl -fsSL "https://github.com/pnpm/pnpm/releases/download/v${PNPM_VERSION}/pnpm-linuxstatic-x64" -o /bin/pnpm && chmod +x /bin/pnpm && \
    apk del curl && \
    (addgroup -S $GROUP_ID || echo "Group $GROUP_ID already exists.") &&\
    (adduser -S $USER_ID -G $GROUP_ID -u $USER_ID || echo "User $USER_ID already exists.") &&\
    mkdir -p /usr/src/app/frontend &&\
    chown -R $USER_ID:$GROUP_ID /usr/src/app
USER $USER_ID
WORKDIR /usr/src/app

COPY --chown=$USER_ID:$GROUP_ID pnpm-lock.yaml pnpm-workspace.yaml /usr/src/app/
COPY --chown=$USER_ID:$GROUP_ID frontend/package.json /usr/src/app/frontend/
RUN pnpm install
COPY --chown=$USER_ID:$GROUP_ID ./frontend /usr/src/app/frontend
RUN pnpm -C '/usr/src/app/frontend' add --save-dev vite
RUN pnpm -C '/usr/src/app/frontend' build

FROM node:lts-alpine
ARG USER_ID
ARG GROUP_ID

RUN (addgroup -S $GROUP_ID || echo "Group $GROUP_ID already exists.") &&\
    (adduser -S $USER_ID -G $GROUP_ID -u $USER_ID || echo "User $USER_ID already exists.") &&\
    mkdir -p /usr/src/app/frontend/build &&\
    chown -R $USER_ID:$GROUP_ID /usr/src/app
USER $USER_ID
WORKDIR /usr/src/app/frontend
COPY --from=builder --chown=$USER_ID:$GROUP_ID /usr/src/app/frontend/package.json /usr/src/app/frontend/package.json
COPY --from=builder --chown=$USER_ID:$GROUP_ID /usr/src/app/frontend/node_modules /usr/src/app/frontend/node_modules
COPY --from=builder --chown=$USER_ID:$GROUP_ID /usr/src/app/frontend/build /usr/src/app/frontend/build

ENTRYPOINT [ "node", "build/index.js" ]