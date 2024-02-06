FROM python:3

LABEL org.opencontainers.image.source = "https://github.com/unchartedsky/macgyver"

SHELL ["/bin/bash", "-c"]


ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH


# Set the timezone to KST
RUN cat /usr/share/zoneinfo/Asia/Seoul > /etc/localtime

RUN useradd --user-group --system --create-home --no-log-init --uid 1000 --shell /bin/bash app

ENV SLACKCAT_VERSION 1.7.3

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list ; \
  curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/Release.key | apt-key add - ; \
  runDeps='curl ca-certificates procps netcat-traditional wget telnet default-mysql-client redis-tools vim-tiny  groff s3curl dnsutils sipcalc tmux percona-toolkit skopeo ftp jq apache2-utils'; \
  buildDeps=''; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  apt-get purge -y --auto-remove $buildDeps; \
  rm /var/log/dpkg.log /var/log/apt/*.log

RUN set -ex; \
  curl --silent -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
  chmod +x ./kubectl; \
  mv ./kubectl /usr/local/bin/kubectl;

RUN curl --silent -Lo jq https://github.com/stedolan/jq/releases/download/jq-1.7/jq-${TARGETOS}-${TARGETARCH} \
  && chmod +x ./jq \
  && mv jq /usr/local/bin/jq

# Create a symbolic link for a user's convenience
RUN /bin/ln -s /usr/bin/vi /usr/bin/vim

RUN curl --silent -Lo slackcat https://github.com/bcicen/slackcat/releases/download/v${SLACKCAT_VERSION}/slackcat-${SLACKCAT_VERSION}-$(uname -s)-${TARGETARCH} \
  && chmod +x slackcat \
  && chown app:app slackcat \
  && mv slackcat /usr/local/bin/

RUN mkdir /tmp/grpcurl \
  && cd /tmp/grpcurl \
  && ( test "${TARGETARCH}" == "amd64" && (curl --silent -L "https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_${TARGETOS}_x86_64.tar.gz" | tar xz) || (curl --silent -L "https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_${TARGETOS}_${TARGETARCH}.tar.gz" | tar xz) ) \
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
  wget https://github.com/nakabonne/ali/releases/download/v0.7.5/ali_0.7.5_${TARGETOS}_${TARGETARCH}.deb; \
  apt install ./ali_0.7.5_${TARGETOS}_${TARGETARCH}.deb; \
  rm -f ./ali_0.7.5_${TARGETOS}_${TARGETARCH}.deb;

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
