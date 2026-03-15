FROM openjdk:17-jdk-slim

ENV JAVA_OPTS="-Djava.net.preferIPv4Stack=true -XX:+UseContainerSupport -XX:MaxRAMPercentage=70.0 -Xss512k -DmaxRunningTime=300 -agentlib:jdwp=transport=dt_socket,server=y,address=9091,suspend=n"

# Install curl or wget to download the files
RUN apt-get update && apt-get install -y wget

# Add the executable
COPY brouter-server/build/libs/brouter-1.6.2-all.jar brouter.jar

# Create the segments folder
RUN mkdir -p /segments4

# Download segment files during the build or at runtime
RUN wget -N -P -O /segments4/W10_N35.rd5 http://brouter.de/brouter/segments4/W10_N35.rd5
RUN wget -N -P -O /segments4/W10_N40.rd5 http://brouter.de/brouter/segments4/W10_N40.rd5

ADD misc/profiles2/ profiles2
ADD misc/customprofiles/ customprofiles

# Informational only or for local development
EXPOSE 17777

# launch the brouter server
CMD ["sh", "-c", "exec java -cp brouter.jar btools.server.RouteServer /segments4 /profiles2 /customprofiles $PORT 1 0.0.0.0"]
