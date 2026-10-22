FROM python:3.15-bookworm

LABEL org.opencontainers.image.source = "https://github.com/unchartedsky/macgyver"

SHELL ["/bin/bash", "-c"]

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

# Set the timezone to KST
RUN cat /usr/share/zoneinfo/Asia/Seoul > /etc/localtime

RUN useradd --user-group --system --create-home --no-log-init --uid 1000 --shell /bin/bash app

ENV SLACKCAT_VERSION="1.7.3"

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_12/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg; \
  echo 'deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_12/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list; \
  runDeps='curl ca-certificates procps netcat-traditional wget telnet default-mysql-client redis-tools vim-tiny groff s3curl dnsutils sipcalc tmux percona-toolkit ftp jq apache2-utils bc'; \
  buildDeps='gnupg2'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  apt-get purge -y --auto-remove $buildDeps; \
  rm /var/log/dpkg.log /var/log/apt/*.log

# Install kubectl (multi-arch, 빌드 시점 최신 stable)
RUN set -ex; \
  curl --silent -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${TARGETOS}/${TARGETARCH}/kubectl"; \
  chmod +x ./kubectl; \
  mv ./kubectl /usr/local/bin/kubectl;

# Install jq 1.8.2 (jqlang 에셋 명명: jq-linux-amd64 / jq-linux-arm64)
RUN curl --silent -Lo jq https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-linux-${TARGETARCH} \
  && chmod +x ./jq \
  && mv jq /usr/local/bin/jq

# Create a symbolic link for a user's convenience
RUN /bin/ln -s /usr/bin/vi /usr/bin/vim

RUN mkdir /tmp/grpcurl \
  && cd /tmp/grpcurl \
  && case "${TARGETARCH}" in \
       amd64) GRPCURL_ARCH="x86_64" ;; \
       *) GRPCURL_ARCH="${TARGETARCH}" ;; \
     esac \
  && curl --silent -L "https://github.com/fullstorydev/grpcurl/releases/download/v1.9.4/grpcurl_1.9.4_${TARGETOS}_${GRPCURL_ARCH}.tar.gz" | tar xz \
  && chmod +x grpcurl \
  && chown app:app grpcurl \
  && mv grpcurl /usr/local/bin/ \
  && rm -rf /tmp/grpcurl

RUN mkdir /tmp/websocketd \
  && cd /tmp/websocketd \
  && curl --silent -Lo websocketd.zip https://github.com/joewalnes/websocketd/releases/download/v0.4.1/websocketd-0.4.1-${TARGETOS}_${TARGETARCH}.zip \
  && unzip websocketd.zip \
  && mv websocketd /usr/local/bin/websocketd \
  && chown app:app /usr/local/bin/websocketd \
  && rm -rf /tmp/websocketd

RUN curl https://rclone.org/install.sh | bash \
  && chown app:app "$(which rclone)"

RUN set -ex; \
  wget https://github.com/nakabonne/ali/releases/download/v0.8.0/ali_0.8.0_${TARGETOS}_${TARGETARCH}.deb; \
  apt install ./ali_0.8.0_${TARGETOS}_${TARGETARCH}.deb; \
  rm -f ./ali_0.8.0_${TARGETOS}_${TARGETARCH}.deb;

RUN set -ex; \
  wget https://github.com/tsenart/vegeta/releases/download/v12.13.0/vegeta_12.13.0_${TARGETOS}_${TARGETARCH}.tar.gz; \
  tar xvfz vegeta_12.13.0_${TARGETOS}_${TARGETARCH}.tar.gz; \
  mv ./vegeta /usr/local/bin/; \
  rm ./vegeta_12.13.0_${TARGETOS}_${TARGETARCH}.tar.gz;

RUN pip install --upgrade pip

COPY requirements.txt /home/app/
RUN chown -R app /home/app/

USER app
WORKDIR /home/app

ENV PATH="/home/app/.local/bin:${PATH}"

COPY requirements.txt /home/app/

RUN pip install --no-cache-dir --user -r requirements.txt

# Sentry.io
ENV SENTRY_DSN ""
