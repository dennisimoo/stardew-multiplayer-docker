# Pull base image
ARG TARGETPLATFORM
ARG BUILDPLATFORM
FROM --platform=${TARGETPLATFORM} jlesage/baseimage-gui:debian-11

# Set the name of the application.
ENV APP_NAME="StardewValley"

# Expose the necessary ports
EXPOSE 5800
EXPOSE 5900
EXPOSE 24642/udp

RUN apt-get update && apt-get install -y wget gnupg ca-certificates \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends mono-runtime mono-utils mono-devel xterm gettext-base jq netcat-openbsd procps unzip tar strace \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/share/.mono/certs/Trust 
#RUN APP_ICON_URL=https://stardewcommunitywiki.com/mediawiki/images/4/48/Fiddlehead_Fern.png && \
#    install_app_icon.sh "$APP_ICON_URL"

# Clean up any existing Stardew directory and extract game files properly
# Ensure final path is "/data/Stardew/Stardew Valley" so SMAPI and COPY targets exist
RUN set -eux; \
    rm -rf /data/Stardew; \
    mkdir -p /data/Stardew /data/nexus /data/_extract; \
    wget https://eris.cc/Stardew_1.6.15.tar.gz -qO /data/latest.tar.gz; \
    tar xf /data/latest.tar.gz -C /data/_extract; \
    mkdir -p "/data/Stardew/Stardew Valley"; \
    if [ -d "/data/_extract/Stardew Valley" ]; then \
        cp -a "/data/_extract/Stardew Valley/." "/data/Stardew/Stardew Valley/"; \
    else \
        cp -a /data/_extract/. "/data/Stardew/Stardew Valley/"; \
    fi; \
    mkdir -p "/data/Stardew/Stardew Valley/Mods"; \
    rm -rf /data/latest.tar.gz /data/_extract

## No mods mode: skip dotnet/SMAPI/mod copies

RUN chmod +x /data/Stardew/Stardew\ Valley/StardewValley && \
    chmod -R 777 /data/Stardew/ && \
    chown -R 1000:1000 /data/Stardew/

## No extra s6 services needed in no-mods mode

COPY docker-entrypoint.sh /startapp.sh
