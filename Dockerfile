FROM eclipse-temurin:17-jre-alpine

RUN apk add --update curl

RUN adduser -S -D -h "/opt/mindustry" mindustry

USER mindustry

WORKDIR "/opt/mindustry"

RUN mkdir "/opt/mindustry/config"

COPY entrypoint.sh "/opt/mindustry/entrypoint.sh"

ENTRYPOINT [ "/opt/mindustry/entrypoint.sh" ]

CMD [ "help,exit" ]

VOLUME [ "/opt/mindustry/config" ]

ARG VERSION=126.2

RUN curl -L -s -o "/opt/mindustry/server.jar" "https://github.com/Anuken/Mindustry/releases/download/v${VERSION}/server-release.jar"
