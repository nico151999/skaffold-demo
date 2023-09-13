ARG USER_ID=1000
ARG GROUP_ID=1000

FROM node:lts-alpine
ARG USER_ID
ARG GROUP_ID

RUN corepack enable && corepack prepare pnpm@latest --activate &&\
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

ENTRYPOINT [ "pnpm", "-C", "/usr/src/app/frontend", "dev", "--host" ]