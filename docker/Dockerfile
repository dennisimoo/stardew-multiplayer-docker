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
RUN rm -rf /data/Stardew && \
    mkdir -p /data/Stardew && \
    mkdir -p /data/nexus && \
    wget https://eris.cc/Stardew_1.6.15.tar.gz -qO /data/latest.tar.gz && \
    tar xf /data/latest.tar.gz -C /data/Stardew --strip-components=1 && \
    rm /data/latest.tar.gz 

# Use .NET runtime
RUN wget -qO dotnet.tar.gz https://download.visualstudio.microsoft.com/download/pr/6788a5a5-1879-4095-948d-72c7fbdf350f/c996151548ec9f24d553817db64c3577/dotnet-sdk-5.0.402-linux-x64.tar.gz \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet 

RUN wget https://github.com/Pathoschild/SMAPI/releases/download/4.1.10/SMAPI-4.1.10-installer.zip -qO /data/nexus.zip && \
    unzip /data/nexus.zip -d /data/nexus/ && \
    /bin/bash -c "SMAPI_NO_TERMINAL=true SMAPI_USE_CURRENT_SHELL=true echo -e \"2\n\n\" | /data/nexus/SMAPI\ 4.1.10\ installer/internal/linux/SMAPI.Installer --install --game-path \"/data/Stardew/Stardew Valley\"" || :

# Add Mods & Scripts first
COPY ["mods/", "/data/Stardew/Stardew Valley/Mods/"]
COPY scripts/ /opt/

# Now copy the AutoLoadGame config file after mods are in place
# Use JSON-array form to handle spaces in destination path
COPY ["./configs/autoload.json", "/data/Stardew/Stardew Valley/Mods/AutoLoadGame/config.json"]

RUN chmod +x /data/Stardew/Stardew\ Valley/StardewValley && \
    chmod -R 777 /data/Stardew/ && \
    chown -R 1000:1000 /data/Stardew/ && \
    chmod +x /opt/*.sh

RUN mkdir /etc/services.d/utils && touch /etc/services.d/app/utils.dep
COPY run /etc/services.d/utils/run 
RUN chmod +x /etc/services.d/utils/run 

COPY docker-entrypoint.sh /startapp.sh
