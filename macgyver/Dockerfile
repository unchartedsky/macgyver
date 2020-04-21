FROM python:3

# Set the timezone to KST
RUN cat /usr/share/zoneinfo/Asia/Seoul > /etc/localtime

ENV KUBERNETES_VERSION 1.17.0
ENV SLACKCAT_VERSION 1.6

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='curl ca-certificates procps netcat wget telnet default-mysql-client redis-tools vim-tiny aws-shell groff s3curl dnsutils sipcalc python-dateutil python-magic'; \
  buildDeps=''; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  \
  curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl; \
  chmod +x ./kubectl; \
  mv ./kubectl /usr/local/bin/kubectl; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm /var/log/dpkg.log /var/log/apt/*.log

RUN curl --silent -Lo jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
  && chmod +x ./jq \
  && mv jq /usr/local/bin/jq

# Create a symbolic link for a user's convenience
RUN /bin/ln -s /usr/bin/vi /usr/bin/vim

RUN curl --silent -Lo slackcat https://github.com/bcicen/slackcat/releases/download/v${SLACKCAT_VERSION}/slackcat-${SLACKCAT_VERSION}-$(uname -s)-amd64 \
	&& chmod +x ./slackcat \
  && mv slackcat /usr/local/bin/

RUN S3CMD_CURRENT_VERSION=`curl --silent -fs https://api.github.com/repos/s3tools/s3cmd/releases/latest | grep tag_name | sed -E 's/.*"v?([0-9\.]+).*/\1/g'` \
    && mkdir -p /opt \
    && wget --quiet https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_CURRENT_VERSION}/s3cmd-${S3CMD_CURRENT_VERSION}.zip \
    && unzip s3cmd-${S3CMD_CURRENT_VERSION}.zip -d /opt/ \
    && ln -s $(find /opt/ -name s3cmd) /usr/local/bin/s3cmd \
    && ls /usr/local/bin/s3cmd

RUN curl --silent -LO https://dl.min.io/client/mc/release/linux-amd64/mc \
  && chmod +x mc \
  && mv mc /usr/local/bin/

RUN curl --silent -Lo websocketd.deb https://github.com/joewalnes/websocketd/releases/download/v0.3.0/websocketd-0.3.0_amd64.deb \
	&& dpkg -i websocketd.deb \
	&& rm websocketd.deb

RUN pip install --upgrade pip

RUN useradd --user-group --system --create-home --no-log-init --uid 1000 --shell /bin/bash app

COPY requirements.txt /home/app/
RUN chown -R app /home/app/

USER app
WORKDIR /home/app

ENV PATH="/home/app/.local/bin:${PATH}"

COPY requirements.txt /home/app/

RUN pip install --no-cache-dir --user -r requirements.txt

# Sentry.io
ENV SENTRY_DSN ""
