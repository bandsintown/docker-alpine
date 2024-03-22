FROM alpine:3.19.1

# Build base image
# Required for Buildkite test/release workflow
ENV S6_OVERLAY_VERSION=1.19.1.1 GODNSMASQ_VERSION=1.0.7 CONSUL_TEMPLATE_VERSION=0.19.4 CONSUL_VERSION=0.7.5

COPY rootfs /

RUN apk update && apk upgrade && \
    apk-install curl wget bash tree jq bind-tools su-exec && \
    chmod u+s /sbin/su-exec && \
    curl -Ls https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar -xz -C / && \
    curl -Ls https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template.zip && unzip consul-template.zip -d /usr/local/bin && \
    curl -Ls https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip && unzip consul.zip -d /usr/local/bin && \
    curl -Ls https://github.com/janeczku/go-dnsmasq/releases/download/${GODNSMASQ_VERSION}/go-dnsmasq-min_linux-amd64 -o /usr/sbin/go-dnsmasq &&  \
    rm -f consul* && \
    chmod +x /usr/sbin/go-dnsmasq && \
    echo -ne "Alpine Linux 3.19.1 image. (`uname -rsv`)\n" >> /root/.built && \
    echo -ne "- with S6 Overlay: $S6_OVERLAY_VERSION, GoDnsMasq: $GODNSMASQ_VERSION, Consul Template: $CONSUL_TEMPLATE_VERSION, Consul: $CONSUL_VERSION\n" >> /root/.built

# Disable S6 logs on stdout/stderr
ENV S6_LOGGING=1

# Enable S6 as default entrypoint
ENTRYPOINT ["/init"]

ENV BATS_VERSION=0.4.0 DOCKERIZE_VERSION=v0.2.0
COPY tests /tests
COPY bin /tests/bin
WORKDIR /tests

RUN exec 2>&1 && apk-install bind-tools bc jq \
    && curl -Ls https://codeload.github.com/sstephenson/bats/zip/v$BATS_VERSION -o /tmp/bats.zip \
	&& cd /tmp \
	&& unzip -q bats.zip \
	&& ./bats-${BATS_VERSION}/install.sh /usr/local \
	&& ln -sf /usr/local/libexec/bats /usr/local/bin/bats \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
	&& rm -f bats.zip dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && mv /tests/consul-template/etc /etc/consul-template

CMD ["bash"]
