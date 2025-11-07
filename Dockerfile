# ✅ Lightweight Java image (Java 21) for Paper 1.21.10
FROM openjdk:21-jdk-slim

WORKDIR /server

# Install dependencies
RUN apt update && apt install -y curl jq unzip && rm -rf /var/lib/apt/lists/*

# === AUTO DOWNLOAD LATEST PAPER 1.21.10 ===
RUN VERSION="1.21.10" && \
    BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$VERSION | jq -r '.builds[-1]') && \
    echo "📦 Downloading Paper $VERSION build $BUILD" && \
    curl -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/$VERSION/builds/$BUILD/downloads/paper-$VERSION-$BUILD.jar"

# === AUTO INSTALL PERFORMANCE MODS ===
RUN mkdir -p plugins && \
    echo "⚙️ Installing optimization plugins..." && \
    curl -L -o plugins/Spark.jar https://github.com/lucko/spark/releases/latest/download/spark-paper.jar && \
    curl -L -o plugins/FastAsyncWorldEdit.jar https://ci.athion.net/job/FastAsyncWorldEdit/lastSuccessfulBuild/artifact/artifacts/FastAsyncWorldEdit-Paper-1.21.10.jar || true && \
    curl -L -o plugins/Chunky.jar https://api.modrinth.com/v2/project/chunky/version/latest/download || true

# Agree to EULA automatically
RUN echo "eula=true" > eula.txt

# Minimal server.properties (optimized)
RUN echo "view-distance=6\nsimulation-distance=4\nmax-tick-time=60000\nmax-players=5\nmotd=§bCulbertMC Server §7| §aOptimized\n" > server.properties

# Expose Minecraft port
EXPOSE 25565

# Create a persistent volume
VOLUME /server

# === START COMMAND ===
CMD ["java", "-Xmx512M", "-Xms512M", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=100", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseStringDeduplication", "-jar", "paper.jar", "--nogui"]
