# grab-site and Docker
Simple containerized [grab-site](https://github.com/ArchiveTeam/grab-site), modified to include support for [proxychains](https://github.com/rofl0r/proxychains-ng) and therefore onions.

 - Web interface will be exposed to **port 29000**
 - Grabbed sites will be saved in **/data**
 - Finished sites can be moved to **/finished**
 - Ability to archive Tor hidden services

## Getting Started Manually
```
git clone https://github.com/codsane/docker-grab-site.git
cd docker-grab-site/
sudo docker build -t "grab-site" .
```
### Running the grab-site server with docker run
```
docker run -d -p 29000:29000 -v /path/to/data:/data --name grab-site-container grab-site
```

## Getting Started with Docker Compose
### Sample of docker-compose.yml
```
version: '3'
services:
  grab-site:
    image: codsane/grab-site
    container_name: grab-site-container
    ports:
        - 29000:29000
    volumes:
        - ./data:/data
        - ./finished:/finished
    restart: unless-stopped
```

### Running the grab-site server with docker-compose
```
docker-compose up -d
```

## Usage
Because our gs-server resides inside a docker container, grab-site must also be run inside the docker container. Rather than running `grab-site 'URL'`, you should run `docker exec grab-site-container grab-site 'URL'` so that `grab-site 'URL'` is ran inside the container.

### Example
The following command will run grab-site against our test URL, inside the docker container, in detached mode (in the background).
```
docker exec -d grab-site-container grab-site https://example.com
```

  

# Archiving Hidden Services
The original goal was to get support for archiving hidden services added to grab-site, however an ongoing [issue](https://github.com/ArchiveTeam/grab-site/issues/148) results in a crash when grab-site passes proxies to wpull with `--wpull-args`.

The latest version of wpull also seems to have issues with proxy support, as I was [unable to resolve onion hostnames](https://github.com/ArchiveTeam/wpull/issues/443) using the proxy implementation built-in.

It also appears [other network issues have risen since the release of wpull v2.0](https://github.com/ArchiveTeam/wpull/issues/406), possibly due to the new network stack introduced since v1.2.3.

## Proxychains

As a workaround, your favorite proxifier/torifier can be used in combination with grab-site to archive hidden services. This project will be using [proxychains](https://github.com/rofl0r/proxychains-ng), as I use [multitor](https://github.com/trimstray/multitor) running in a seperate container to serve as my Tor gateway. If you're simply looking to bring .onion support to your local grab-site instance and don't already have a Tor-capable proxy setup, I'd suggest [torsocks](https://github.com/dgoulet/torsocks) in place of proxychains.

By default proxychains is setup to proxy DNS requests to prevent leaks. This has the added bonus of ensuring DNS resolutions are done by the proxy, ensuring hidden services are able to be reached by wpull.

## Usage
In order for proxified crawls to be tracked by the grab-site dashboard, connections to localhost should be excluded from your proxifier. If deploying docker-grab-site from this repository, necessary exclusions are made by default in the provided [proxychains.conf](https://github.com/codsane/docker-grab-site/blob/master/proxychains.conf#L22) file. If you're not deploying an identical setup with multitor, you **will** need to edit the [ProxyList] portion of this configuration file.

### Example
The following command will run a proxified grab-site against our test URL.
```
docker exec -d grab-site-container proxychains4 grab-site http://expyuzz4wqqyqhjn.onion
```
