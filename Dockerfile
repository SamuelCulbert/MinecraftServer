# ✅ Lightweight Java 21 image for PaperMC 1.21.10
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /server

# Install dependencies
RUN apt update && apt install -y curl jq && rm -rf /var/lib/apt/lists/*

# Automatically fetch latest Paper build for 1.21.10
RUN VERSION="1.21.10" && \
    BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$VERSION | jq -r '.builds[-1]') && \
    echo "📦 Downloading Paper $VERSION build $BUILD" && \
    curl -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/$VERSION/builds/$BUILD/downloads/paper-$VERSION-$BUILD.jar"

# Automatically agree to EULA
RUN echo "eula=true" > eula.txt

# Expose Minecraft port
EXPOSE 25565

# Optional persistent data volume
VOLUME /server

# Start Paper server with 1GB RAM
CMD ["java", "-Xmx1G", "-Xms1G", "-jar", "paper.jar", "--nogui"]
