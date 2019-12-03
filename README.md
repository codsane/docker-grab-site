# grab-site and Docker
Simple containerized [grab-site](https://github.com/ArchiveTeam/grab-site), modified to include support for proxychains-ng and therefore onions.

 - Web interface will be exposed to **port 29000**
 - Grabbed sites will be saved in **/data**
 - Finished sites can be moved to **/finished**

## Getting Started Manually
```
git clone https://github.com/codsane/docker-grab-site.git
cd docker-grab-site/
sudo docker build -t "grab-site" .
```
### Running the grab-site server with docker run
```
docker run -d --rm -p 29000:29000 -v /path/to/data:/data --name grab-site-container grab-site
```

## Using Docker-Compose
### Sample docker-compose.yml:
```
version: '3'
services:
  grabsite:
    image: codsane/grab-site
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
Because our gs-server resides inside the docker container, 
```
docker exec grab-site-container grab-site --my-grab-site-options https://example.com
```

