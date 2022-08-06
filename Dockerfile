FROM debian:stretch-slim

RUN groupadd -r litecoin && useradd -r -m -g litecoin litecoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget curl \
	&& rm -rf /var/lib/apt/lists/*

ENV LITECOIN_VERSION 0.18.1
ENV LITECOIN_URL https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz
ENV LITECOIN_SHA256 ca50936299e2c5a66b954c266dcaaeef9e91b2f5307069b9894048acf3eb5751
ENV LITECOIN_ASC_URL https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux-signatures.asc
ENV LITECOIN_PGP_KEY FE3348877809386C

# install litecoin binaries and verify checksum
RUN set -ex \
	&& cd /tmp \
	&& wget -qO litecoin.tar.gz "$LITECOIN_URL" \
	&& echo "$LITECOIN_SHA256 litecoin.tar.gz" | sha256sum -c - \
	&& gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$LITECOIN_PGP_KEY" \
	&& wget -qO litecoin.asc "$LITECOIN_ASC_URL" \
	&& gpg --verify litecoin.asc \
	&& tar -xzvf litecoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
ENV LITECOIN_DATA /data
RUN mkdir "$LITECOIN_DATA" \
	&& chown -R litecoin:litecoin "$LITECOIN_DATA" \
	&& ln -sfn "$LITECOIN_DATA" /home/litecoin/.litecoin \
	&& chown -h litecoin:litecoin /home/litecoin/.litecoin
VOLUME /data

# scan with trivy
#RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin \
#    && trivy filesystem --exit-code 1 --no-progress /

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9332
CMD ["litecoind"]