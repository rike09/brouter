# --- STAGE 1: Build the JAR ---
FROM eclipse-temurin:11-jdk-jammy AS builder
WORKDIR /app

# Copy the entire project
COPY . .

# Build the project (Using the Gradle wrapper included in BRouter)
# Use ./mvnw package if you are using Maven instead
RUN ./gradlew clean build fatjar

# --- STAGE 2: Run the Server ---
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

ENV JAVA_OPTS="-Djava.net.preferIPv4Stack=true -XX:+UseContainerSupport -XX:MaxRAMPercentage=70.0 -Xss512k -DmaxRunningTime=300 -agentlib:jdwp=transport=dt_socket,server=y,address=9091,suspend=n"

# Install wget for your segments
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Copy ONLY the resulting JAR from the builder stage
# Note: The path might be 'build/libs/brouter.jar' depending on your version
COPY --from=builder /app/brouter-server/build/libs/brouter*-all.jar brouter.jar

# Copy your profiles and other necessary folders
COPY misc/profiles2 ./profiles2
COPY misc/customprofiles ./customprofiles

# Create segments directory
RUN mkdir -p /segments4

# Informational only or for local development
EXPOSE 17777

# launch the brouter server
CMD ["sh", "-c", "wget -N -P /app/segments4 http://brouter.de/brouter/segments4/W10_N35.rd5 && wget -N -P /app/segments4 http://brouter.de/brouter/segments4/W10_N40.rd5 && java -cp brouter.jar btools.server.RouteServer /app/segments4 /app/profiles2 /app/customprofiles $PORT 1 0.0.0.0"]
