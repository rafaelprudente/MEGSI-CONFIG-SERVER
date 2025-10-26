FROM --platform=linux/arm64 bellsoft/liberica-openjre-debian:21

WORKDIR /opt
ENV SERVER_PORT=8888
ENV LOG_LEVEL=INFO
ENV GIT_URI=https://github.com/rafaelprudente/MEGSI-ITI-CONFIG-SERVER.git
ENV GIT_BRANCH=main

EXPOSE 8888

COPY target/*.jar /opt/app.jar

ENTRYPOINT ["/bin/sh", "-c", "java -jar /opt/app.jar"]