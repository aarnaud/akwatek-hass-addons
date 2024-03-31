ARG BUILD_FROM
FROM ghcr.io/aarnaud/akwatek-mqtt-bridge:latest  AS build-image


# Start from a clean image, and import only required files
FROM $BUILD_FROM as addon-image

LABEL org.opencontainers.image.title="Home Assistant Add-on: Akwatek"
LABEL org.opencontainers.image.description="Akwatek-hass-addon"
LABEL org.opencontainers.image.source="https://github.com/aarnaud/akwatek-hass-addons"
LABEL org.opencontainers.image.authors="Anthony A."
LABEL org.opencontainers.image.licenses="Apache License 2.0"

ARG BUILD_ARCH
COPY --from=build-image /app /app
ENV GIN_MODE=release
WORKDIR /app
COPY . .
RUN chmod +x entrypoint.sh
CMD ["./entrypoint.sh"]
