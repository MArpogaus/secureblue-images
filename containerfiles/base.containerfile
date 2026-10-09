# Generic base for all hardened images. The CI matrix supplies BASE_IMAGE
# (the upstream secureblue image) and EXTRA_PACKAGES as build args.
# ref: https://github.com/ublue-os/image-template/blob/main/Containerfile

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY common /

# Base Image
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG EXTRA_PACKAGES=
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    EXTRA_PACKAGES="${EXTRA_PACKAGES}" /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint --skip etc-usretc
