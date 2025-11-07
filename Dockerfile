FROM openjdk:21-jdk-slim
WORKDIR /server

# Install curl and jq
RUN apt-get update && apt-get install -y curl jq && rm -rf /var/lib/apt/lists/*

# Download the latest Paper build for 1.21.10 at build time
RUN VERSION="1.21.10" && \
    BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$VERSION | jq -r '.builds[-1]') && \
    curl -L -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/$VERSION/builds/$BUILD/downloads/paper-$VERSION-$BUILD.jar" && \
    echo "eula=true" > eula.txt && \
    echo "motd=CulbertMC 256MB Server" > server.properties && \
    echo "view-distance=4\nsimulation-distance=3\nmax-players=3" >> server.properties

EXPOSE 25565
VOLUME /server
CMD ["java", "-Xmx256M", "-Xms256M", "-jar", "paper.jar", "--nogui"]
