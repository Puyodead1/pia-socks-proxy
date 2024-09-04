FROM ubuntu:20.04

EXPOSE 1080

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y supervisor openvpn dante-server wget ca-certificates unzip python3-pip git && \
	pip3 install git+https://github.com/coderanger/supervisor-stdout && \
	mkdir -p /var/log/supervisor && \
	wget -q https://www.privateinternetaccess.com/openvpn/openvpn.zip \
			https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip \
			https://www.privateinternetaccess.com/openvpn/openvpn-tcp.zip \
			https://www.privateinternetaccess.com/openvpn/openvpn-strong-tcp.zip && \
	mkdir -p /openvpn/ && \
	unzip -q openvpn.zip -d /openvpn/udp-normal && \
	unzip -q openvpn-strong.zip -d /openvpn/udp-strong && \
	unzip -q openvpn-tcp.zip -d /openvpn/tcp-normal && \
	unzip -q openvpn-strong-tcp.zip -d /openvpn/tcp-strong && \
	rm -rf /*.zip

COPY ./app /app
# COPY ./etc /etc
COPY conf/danted.conf /etc/
COPY conf/supervisord.conf /etc/supervisor/supervisord.conf
COPY conf/resolve.conf /etc/resolv.conf

# COPY --from=qmcgaw/dns-trustanchor /named.root /etc/unbound/root.hints
# COPY --from=qmcgaw/dns-trustanchor /root.key /etc/unbound/root.key

RUN chmod 500 /app/openvpn_kill.sh /app/openvpn_run.sh

ENV REGION="US Chicago" \
	USERNAME="p9972341" \
	PASSWORD="P8zX4j6QAH" \
	ENCRYPTION=normal \
	PROTOCOL=tcp

ENTRYPOINT ["/usr/bin/supervisord"]