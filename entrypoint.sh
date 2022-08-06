#!/bin/bash
set -e

if [[ "$1" == "litecoind" ]]; then
	mkdir -p "$LITECOIN_DATA"

	cat <<-EOF > "$LITECOIN_DATA/litecoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	${LITECOIN_EXTRA_ARGS}
	EOF
	chown litecoin:litecoin "$LITECOIN_DATA/litecoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R litecoin "$LITECOIN_DATA"
	ln -sfn "$LITECOIN_DATA" /home/litecoin/.litecoin
	chown -h litecoin:litecoin /home/litecoin/.litecoin

	exec gosu litecoin "$@"
else
	exec "$@"
fi