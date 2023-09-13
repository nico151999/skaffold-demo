ARG BUILD_PATH="/tmp/backend-service"
ARG BUILD_TARGET="$BUILD_PATH/backend"
ARG GROUP_ID=1000
ARG USER_ID=1000


FROM golang:1.20-alpine AS build_base
ARG BUILD_PATH
ARG BUILD_TARGET

RUN apk add --no-cache git

WORKDIR $BUILD_PATH

COPY go.mod $BUILD_PATH/
RUN go mod download

COPY cmd $BUILD_PATH/cmd
COPY internal $BUILD_PATH/internal

RUN --mount=type=cache,target=~/.cache/go-build \
    CGO_ENABLED=0 go build -o $BUILD_TARGET github.com/nico151999/skaffold-demo/cmd


# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
ARG BUILD_TARGET
ARG GROUP_ID
ARG USER_ID

COPY --from=build_base $BUILD_TARGET /app/server
USER $USER_ID:$GROUP_ID

EXPOSE 8080

ENTRYPOINT ["/app/server"]