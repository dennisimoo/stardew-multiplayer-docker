FROM jlesage/baseimage-gui:debian-10

ENV APP_NAME="StardewValley"

RUN apt-get update && \
    apt-get install -y wget unzip tar strace mono-complete xterm gettext-base jq netcat procps && \
    rm -rf /var/lib/apt/lists/*

# Game + ModLoader
RUN mkdir -p /data/Stardew && \
    mkdir -p /data/nexus && \
    wget https://eris.cc/Stardew_1.6.15.tar.gz -qO /data/latest.tar.gz && \
    tar xf /data/latest.tar.gz -C /data/Stardew && \
    rm /data/latest.tar.gz 

# Install .NET SDK
RUN wget -qO dotnet.tar.gz https://download.visualstudio.microsoft.com/download/pr/6788a5a5-1879-4095-948d-72c7fbdf350f/c996151548ec9f24d553817db64c3577/dotnet-sdk-5.0.402-linux-x64.tar.gz && \
    tar -zxf dotnet.tar.gz -C /usr/share/dotnet && \
    rm dotnet.tar.gz && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet 

# Install SMAPI
RUN wget https://github.com/Pathoschild/SMAPI/releases/download/4.1.10/SMAPI-4.1.10-installer.zip -qO /data/nexus.zip && \
    unzip /data/nexus.zip -d /data/nexus/ && \
    /bin/bash -c "SMAPI_NO_TERMINAL=true SMAPI_USE_CURRENT_SHELL=true echo -e \"2\n\n\" | /data/nexus/SMAPI\ 4.1.10\ installer/internal/linux/SMAPI.Installer --install --game-path \"/data/Stardew/Stardew Valley\"" || :

# Add Mods & Scripts
COPY mods/ /data/Stardew/Stardew\ Valley/Mods/
COPY scripts/ /opt/

# Set permissions
RUN chmod +x /data/Stardew/Stardew\ Valley/StardewValley && \
    chmod -R 777 /data/Stardew/ && \
    chown -R 1000:1000 /data/Stardew && \
    chmod +x /opt/*.sh

# Configure services
RUN mkdir /etc/services.d/utils && touch /etc/services.d/app/utils.dep
COPY run /etc/services.d/utils/run 
RUN chmod +x /etc/services.d/utils/run 

COPY docker-entrypoint.sh /startapp.sh

# Expose ports
EXPOSE 5900 5800 24642/udp

# Default environment variables
ENV VNC_PASSWORD=nyanyanya \
    DISPLAY_HEIGHT=900 \
    DISPLAY_WIDTH=1200 \
    ENABLE_ALWAYSONSERVER_MOD=true \
    ENABLE_UNLIMITEDPLAYERS_MOD=true \
    ENABLE_AUTOLOADGAME_MOD=true \
    ENABLE_REMOTECONTROL_MOD=true \
    ENABLE_SAVEBACKUP_MOD=true

# Create volume mount points
VOLUME ["/config/xdg/config/StardewValley/Saves"]