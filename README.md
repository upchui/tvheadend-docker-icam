


## **thealhu´s flaver of TVHeadend**
![](https://i.ibb.co/b20nP39/TVHeadend-Docker-Image-new.png)

 - **ICAM support**
	> In these TVHeadend docker images, icam support is built-in.

**The architectures supported by this image are:** 
| Architectures | Status | Tag |Additional information |
|--|--|--|--|
| amd64 | ✅ | thealhu/tvheadend:latest | |
| aarch64 | ✅ | thealhu/tvheadend:aarch64-latest | `for raspberry pi & other single board computers on aarch64` for example: PI 3 & PI 4 with 64 bit OS|
| armv7 | ❌ | thealhu/tvheadend:armv7-latest | **Deprecated! - [linuxserver alpine linux no longer offers support for armv7](https://github.com/linuxserver/docker-tvheadend/commit/79481854219e79fc5770799797b3b426bb5c4a98)**|

*This image was built on the basis of [linuxserver/docker-tvheadend](https://github.com/linuxserver/docker-tvheadend) and is always kept and updated to the same version.*

**The container images are automatically built through a Jenkins pipeline as soon as a commit is checked into the [TVHeadend git repository](https://github.com/tvheadend/tvheadend) or [Linuxserver docker-TVHeadend git repository](https://github.com/linuxserver/docker-tvheadend)**

If you want to build the image yourself, everything you need can be found [here](https://github.com/upchui/tvheadend-docker-icam).

## ICAM
### What is ICAM?

ICAM stands for "Integrated Conditional Access Module". It is a security module that can be built into some digital satellite receivers or set-top boxes. It is used to access encrypted channels that require separate activation. The ICAM is used to perform the decryption of the encrypted signals being broadcast by the satellite. It contains a security chip that enables authentication and access to the encrypted channels. The receiver must be equipped with a valid smart card or other security module in order to access the encrypted channels.

**In these TVHeadend docker images, icam support is built-in.**

## Usage
### docker-compose (recommended)

```yaml
---
version: "2.1"
services:
  tvheadend:
    image: thealhu/tvheadend:latest #or thealhu/tvheadend:aarch64-latest depending on the architecture of your CPU
    container_name: tvheadend
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Vienna
      - RUN_OPTS= #optional
    volumes:
      - /path/to/data:/config
      - /path/to/recordings:/recordings
    ports:
      - 9981:9981
      - 9982:9982
    devices:
      - /dev/dri:/dev/dri #optional
      - /dev/dvb:/dev/dvb #optional
    restart: unless-stopped

```
### docker cli 

```bash
docker run -d \
  --name=tvheadend \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Vienna \
  -e RUN_OPTS= `#optional` \
  -p 9981:9981 \
  -p 9982:9982 \
  -v /path/to/data:/config \
  -v /path/to/recordings:/recordings \
  --device /dev/dri:/dev/dri `#optional` \
  --device /dev/dvb:/dev/dvb `#optional` \
  --restart unless-stopped \
  thealhu/tvheadend:latest #or thealhu/tvheadend:aarch64-latest depending on the architecture of your CPU

```
#### Host vs. Bridge

If you use IPTV, SAT>IP or HDHomeRun, you need to create the container with --net=host and remove the -p flags. This is because to work with these services Tvheadend requires a multicast address of `239.255.255.250` and a UDP port of `1900` which at this time is not possible with docker bridge mode. If you have other host services which also use multicast such as SSDP/DLNA/Emby you may experience stabilty problems. These can be solved by giving tvheadend its own IP using macvlan.

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

Parameter

Function

`-p 9981`

WebUI

`-p 9982`

HTSP server port.

`-e PUID=1000`

for UserID - see below for explanation

`-e PGID=1000`

for GroupID - see below for explanation

`-e TZ=Europe/London`

Specify a timezone to use EG Europe/London.

`-e RUN_OPTS=`

Optionally specify additional arguments to be passed. See Additional runtime parameters.

`-v /config`

Where TVHeadend show store it's config files.

`-v /recordings`

Where you want the PVR to store recordings.

`--device /dev/dri`

Only needed if you want to use your AMD/Intel GPU for hardware accelerated video encoding (vaapi).

`--device /dev/dvb`

Only needed if you want to pass through a DVB card to the container. If you use IPTV or HDHomeRun you can leave it out.

`-e heartbeat_alive=false`

Do not send heartbeat packets to amplitude.com, this is used to determine how many are using this docker image

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword

```

Will set the environment variable `PASSWORD` based on the contents of the `/run/secrets/mysecretpassword` file.

## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting. Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask)

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)

```

## Updating Info

### Via Docker Compose

-   Update all images: `docker-compose pull`
    -   or update a single image: `docker-compose pull tvheadend`
-   Let compose update all containers as necessary: `docker-compose up -d`
    -   or update a single container: `docker-compose up -d tvheadend`
-   You can also remove the old dangling images: `docker image prune`

### Via Docker Run

-   Update the image: `docker pull thealhu/tvheadend:latest`
-   Stop the running container: `docker stop tvheadend`
-   Delete the container: `docker rm tvheadend`
-   Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
-   You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (only use if you don't remember the original parameters)

-   Pull the latest image at its tag and replace it with the same env variables in one run:
    
    ```bash
    docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower \
    --run-once tvheadend
    
    ```
    
-   You can also remove the old dangling images: `docker image prune`
    

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using [Docker Compose](https://docs.linuxserver.io/general/docker-compose).

## Thanks for support to
| Contributor |  |
|--|--|
|  [Serbus](https://www.kodinerds.net/index.php/User/23768-Serbus/)  | for the help in fixing the [simple EPG file grabber](https://github.com/b-jesch/tv_grab_file) |
| [PvD](https://www.kodinerds.net/index.php/User/20365-PvD/) | for the providing and developing of the [simple EPG file grabber](https://github.com/b-jesch/tv_grab_file) |



## AUTOMATICALLY NEW IMAGES

**Container images will now be automatically built through Jenkins pipeline as soon as a commit is checked in on the [TVHeadend git repository](https://github.com/tvheadend/tvheadend) or [Linuxserver docker-TVHeadend git repository](https://github.com/linuxserver/docker-tvheadend).**



