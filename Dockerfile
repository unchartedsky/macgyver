FROM python:3

# Set the timezone to KST
RUN cat /usr/share/zoneinfo/Asia/Seoul > /etc/localtime

ENV KUBERNETES_VERSION 1.17.0
ENV S3CMD_VERSION 2.0.2
ENV SLACKCAT_VERSION 1.6

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='curl ca-certificates procps netcat wget telnet default-mysql-client redis-tools vim-tiny aws-shell groff s3curl dnsutils sipcalc'; \
  buildDeps=''; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl; \
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

RUN curl --silent -LO https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_VERSION}/s3cmd-${S3CMD_VERSION}.tar.gz \
  && tar xvfz s3cmd-${S3CMD_VERSION}.tar.gz \
  && mv s3cmd-${S3CMD_VERSION}/s3cmd /usr/local/bin/ \
  && rm -rf s3cmd-${S3CMD_VERSION} && rm s3cmd-${S3CMD_VERSION}.tar.gz

RUN curl --silent -Lo websocketd.deb https://github.com/joewalnes/websocketd/releases/download/v0.3.0/websocketd-0.3.0_amd64.deb \
	&& dpkg -i websocketd.deb \
	&& rm websocketd.deb

WORKDIR /

COPY requirements.txt /

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Sentry.io
ENV SENTRY_DSN ""
