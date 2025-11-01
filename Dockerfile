FROM bellsoft/liberica-openjre-debian:21

WORKDIR /opt
ENV SERVER_PORT=8888
ENV LOG_LEVEL=INFO
ENV GIT_URI=git@github.com:rafaelprudente/MEGSI-CONFIG-SERVER-DATA.git
ENV GIT_BRANCH=main

EXPOSE 8888

RUN apt-get update && \
    apt-get install -y openssh-client && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan github.com > ~/.ssh/known_hosts && \
    echo "Host github.com" > /root/.ssh/config && \
    echo "  HostName github.com" >> /root/.ssh/config && \
    echo "  User git" >> /root/.ssh/config && \
    echo "  IdentityFile ~/.ssh/megsi-config-server" >> /root/.ssh/config && \
    echo "  IdentitiesOnly yes" >> /root/.ssh/config && \
    chmod 600 /root/.ssh/config

COPY gitHub/megsi-config-server /root/.ssh/megsi-config-server
COPY gitHub/megsi-config-server.pub /root/.ssh/megsi-config-server.pub

COPY target/*.jar /opt/app.jar

ENTRYPOINT ["/bin/sh", "-c", "java -jar /opt/app.jar"]