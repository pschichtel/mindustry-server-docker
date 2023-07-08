FROM docker.io/library/eclipse-temurin:17-jdk-jammy AS tcp-wrapper

RUN apt-get update \
 && apt-get install -y --no-install-recommends git

WORKDIR /src

ARG TCP_WRAPPER_REF=main

RUN git clone --depth=1 -b "$TCP_WRAPPER_REF" https://github.com/pschichtel/tcp-process-wrapper.git .

RUN ./gradlew linkReleaseExecutableNative

FROM docker.io/curlimages/curl:8.1.2 AS mindustry

ARG VERSION=145.1

RUN curl -L -s -o "/tmp/server.jar" "https://github.com/Anuken/Mindustry/releases/download/v${VERSION}/server-release.jar"

FROM docker.io/library/eclipse-temurin:17-jre-jammy

RUN apt-get update \
 && apt-get install -y --no-install-recommends bash \
 && apt-get clean

COPY --from=tcp-wrapper /src/build/bin/native/releaseExecutable/tcp-wrapper.kexe /usr/local/bin/tcp-wrapper

RUN adduser --system --home /opt/mindustry --group mindustry

USER mindustry

WORKDIR "/opt/mindustry"

RUN mkdir -p "/opt/mindustry/config" "/opt/mindustry/pipes"

ENTRYPOINT [ "/opt/mindustry/entrypoint.sh" ]

CMD [ "help", "exit" ]

VOLUME [ "/opt/mindustry/config" ]

COPY --from=mindustry "/tmp/server.jar" "/opt/mindustry/server.jar"

COPY entrypoint.sh "/opt/mindustry/entrypoint.sh"
