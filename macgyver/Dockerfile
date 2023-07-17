FROM python:3

LABEL org.opencontainers.image.source = "https://github.com/unchartedsky/macgyver"

SHELL ["/bin/bash", "-c"]

# Set the timezone to KST
RUN cat /usr/share/zoneinfo/Asia/Seoul > /etc/localtime

RUN useradd --user-group --system --create-home --no-log-init --uid 1000 --shell /bin/bash app

ENV SLACKCAT_VERSION 1.7.2

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='curl ca-certificates procps netcat-traditional wget telnet default-mysql-client redis-tools vim-tiny groff s3curl dnsutils sipcalc tmux percona-toolkit ftp jq'; \
  buildDeps=''; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  apt-get purge -y --auto-remove $buildDeps; \
  rm /var/log/dpkg.log /var/log/apt/*.log

RUN set -ex; \
  curl --silent -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
  chmod +x ./kubectl; \
  mv ./kubectl /usr/local/bin/kubectl;

# Create a symbolic link for a user's convenience
RUN /bin/ln -s /usr/bin/vi /usr/bin/vim

RUN curl --silent -Lo slackcat https://github.com/bcicen/slackcat/releases/download/v${SLACKCAT_VERSION}/slackcat-${SLACKCAT_VERSION}-$(uname -s)-amd64 \
  && chmod +x slackcat \
  && chown app:app slackcat \
  && mv slackcat /usr/local/bin/

RUN S3CMD_CURRENT_VERSION=`curl --silent -fs https://api.github.com/repos/s3tools/s3cmd/releases/latest | grep tag_name | sed -E 's/.*"v?([0-9\.]+).*/\1/g'` \
  && mkdir -p /opt \
  && wget --quiet https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_CURRENT_VERSION}/s3cmd-${S3CMD_CURRENT_VERSION}.zip \
  && unzip s3cmd-${S3CMD_CURRENT_VERSION}.zip -d /opt/ \
  && ln -s $(find /opt/ -name s3cmd) /usr/local/bin/s3cmd \
  && ls /usr/local/bin/s3cmd

RUN curl --silent -L https://github.com/fullstorydev/grpcurl/releases/download/v1.8.0/grpcurl_1.8.0_linux_x86_64.tar.gz | tar xz \
  && chmod +x grpcurl \
  && chown app:app grpcurl \
  && mv grpcurl /usr/local/bin/

RUN mkdir -p /tmp/websocketd \
  && pushd /tmp/websocketd \
  && curl --silent -Lo websocketd.zip https://github.com/joewalnes/websocketd/releases/download/v0.4.1/websocketd-0.4.1-linux_amd64.zip \
  && unzip websocketd.zip \
  && mv websocketd /usr/local/bin/ \
  && chmod +x /usr/local/bin/websocketd \
  && popd \
  && rm -rf /tmp/websocketd

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
