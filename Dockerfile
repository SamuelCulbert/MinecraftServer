# ✅ Lightweight Java 21 image for Minecraft 1.21.10
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /server

# Install basic tools
RUN apt update && apt install -y curl jq unzip && rm -rf /var/lib/apt/lists/*

# === AUTO-DOWNLOAD LATEST PAPER 1.21.10 ===
RUN VERSION="1.21.10" && \
    BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$VERSION | jq -r '.builds[-1]') && \
    echo "📦 Downloading Paper $VERSION build $BUILD" && \
    curl -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/$VERSION/builds/$BUILD/downloads/paper-$VERSION-$BUILD.jar"

# === CREATE BASIC CONFIGURATION ===
RUN echo "eula=true" > eula.txt && \
    echo "motd=§bCulbertMC Server §7| §a256MB Edition\n" > server.properties && \
    echo "view-distance=4\nsimulation-distance=3\nmax-players=3\nmax-tick-time=60000\nlevel-name=world\n" >> server.properties

# Expose Minecraft port
EXPOSE 25565

# Create a persistent volume (for world save)
VOLUME /server

# === LAUNCH OPTIMIZED JAVA FOR 256MB ===
CMD ["java", "-Xmx256M", "-Xms256M", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=200", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseStringDeduplication", "-jar", "paper.jar", "--nogui"]
