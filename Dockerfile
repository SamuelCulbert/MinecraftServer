# Use lightweight Java 21 base
FROM openjdk:21-jdk-slim

# Create working directory
WORKDIR /server

# Install curl and jq for downloading PaperMC
RUN apt-get update && apt-get install -y curl jq && rm -rf /var/lib/apt/lists/*

# Set Paper version (Minecraft 1.21.10)
ENV VERSION=1.21.10

# Download the latest Paper build for the version
RUN BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/${VERSION} | jq -r '.builds[-1]') && \
    curl -L -o paper.jar https://api.papermc.io/v2/projects/paper/versions/${VERSION}/builds/${BUILD}/downloads/paper-${VERSION}-${BUILD}.jar && \
    echo "eula=true" > eula.txt && \
    echo "motd=Render.com PaperMC 1.21.10" > server.properties && \
    echo "view-distance=4\nsimulation-distance=3\nmax-players=5\nonline-mode=false" >> server.properties

EXPOSE 25565

# Start the Paper server
CMD ["java", "-Xmx512M", "-Xms512M", "-XX:+UseG1GC", "-jar", "paper.jar", "--nogui"]
