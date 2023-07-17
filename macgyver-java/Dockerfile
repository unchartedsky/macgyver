FROM ghcr.io/unchartedsky/macgyver:latest

LABEL org.opencontainers.image.source = "https://github.com/unchartedsky/macgyver"

USER root

RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive; \
    # echo 'deb http://ftp.de.debian.org/debian sid main' >> '/etc/apt/sources.list' ; \
    runDeps='default-jre-headless'; \
    buildDeps=''; \
    apt-get update; \
    # mkdir -p /usr/share/man/man1 && \
    apt-get install -y $runDeps $buildDeps --no-install-recommends; \
    rm -rf /var/lib/apt/lists/*; \
    apt-get purge -y --auto-remove $buildDeps; \
    rm /var/log/dpkg.log /var/log/apt/*.log

USER app
