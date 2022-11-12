FROM alpine:3.16 AS builder

RUN apk add --update --no-cache curl

ARG VERSION=140.3

RUN curl -L -s -o "/server.jar" "https://github.com/Anuken/Mindustry/releases/download/v${VERSION}/server-release.jar"

FROM eclipse-temurin:17-jre-alpine

RUN adduser -S -D -h "/opt/mindustry" mindustry

USER mindustry

WORKDIR "/opt/mindustry"

RUN mkdir "/opt/mindustry/config"

COPY entrypoint.sh "/opt/mindustry/entrypoint.sh"

ENTRYPOINT [ "/opt/mindustry/entrypoint.sh" ]

CMD [ "help,exit" ]

VOLUME [ "/opt/mindustry/config" ]

COPY --from=builder "/server.jar" "/opt/mindustry/server.jar"
