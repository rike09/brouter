FROM eclipse-temurin:17-jdk-jammy

ENV JAVA_OPTS="-Djava.net.preferIPv4Stack=true -XX:+UseContainerSupport -XX:MaxRAMPercentage=70.0 -Xss512k -DmaxRunningTime=300 -agentlib:jdwp=transport=dt_socket,server=y,address=9091,suspend=n"

# Install curl or wget to download the files
RUN apt-get update && apt-get install -y wget

# Copy necessary files
COPY brouter-server/build/libs/brouter-1.6.2-all.jar brouter.jar
RUN mkdir -p /segments4
ADD misc/profiles2/ profiles2
ADD misc/customprofiles/ customprofiles

# Informational only or for local development
EXPOSE 17777

# launch the brouter server
CMD ["sh", "-c", "wget -N -P /segments4 http://brouter.de/brouter/segments4/W10_N35.rd5 && wget -N -P /segments4 http://brouter.de/brouter/segments4/W10_N40.rd5 && java -cp brouter.jar btools.server.RouteServer /segments4 /profiles2 /customprofiles $PORT 1 0.0.0.0"]
