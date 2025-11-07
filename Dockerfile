# Use an official OpenJDK image
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /server

# Download the PaperMC server jar (latest 1.21)
RUN apt update && apt install -y curl && \
    curl -o paper.jar https://api.papermc.io/v2/projects/paper/versions/1.21.10/builds/120/downloads/paper-1.21.10-120.jar

# Expose Minecraft default port
EXPOSE 25565

# Automatically agree to EULA
RUN echo "eula=true" > eula.txt

# Start the server
CMD ["java", "-Xmx1G", "-Xms1G", "-jar", "paper.jar", "--nogui"]
