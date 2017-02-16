FROM cargo.caicloud.io/caicloud/debian:jessie

RUN sed -i "s/httpredir.debian.org/mirrors.163.com/g" /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get install -qy jq curl
COPY dashboards /dashboards
COPY run.sh /

CMD ["./run.sh"]
