FROM openjdk:17-jdk-slim

COPY brouter-server/build/libs/brouter-1.6.2-all.jar brouter.jar
ADD misc/segments4/ segments4
ADD misc/profiles2/ profiles2
ADD misc/customprofiles/ customprofiles

EXPOSE 17777

ENV JAVA_OPTS="-Djava.net.preferIPv4Stack=true -XX:+UseContainerSupport -XX:MaxRAMPercentage=70.0 -Xss512k -DmaxRunningTime=300 -agentlib:jdwp=transport=dt_socket,server=y,address=9091,suspend=n"

CMD ["java", "-cp", "brouter.jar", "btools.server.RouteServer", "/segments4", "/profiles2", "/customprofiles", "17777", "1", "0.0.0.0"]
