FROM python:3.7-slim-stretch

ENV BUILD_PACKAGES="git build-essential" \
    PACKAGES="libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev libxml2-dev libxslt1-dev libre2-dev pkg-config"

# Install requirements
RUN apt-get update && \
	apt-get install --no-install-recommends -y $BUILD_PACKAGES $PACKAGES

# Install proxychains-ng
RUN cd /tmp/ && git clone https://github.com/rofl0r/proxychains-ng.git && \
	cd proxychains-ng && \
	./configure && \
	make && \
	make install

# Install grab-site
RUN pip3 install --no-binary lxml --upgrade git+https://github.com/ArchiveTeam/grab-site

# Clean up
RUN apt-get purge -y \
	$BUILD_PACKAGES pkg-config && \
	apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

VOLUME /data
VOLUME /finished
WORKDIR /data
EXPOSE 29000
COPY ["proxychains.conf", "/etc/proxychains.conf"]
CMD ["python", "/usr/local/bin/gs-server"]