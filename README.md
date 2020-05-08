# shairport-sync
[![](https://images.microbadger.com/badges/image/mxtnr/shairport-sync.svg)](https://microbadger.com/images/mxtnr/shairport-sync "Get your own image badge on microbadger.com")

Dockerized version of [shairport-sync](https://github.com/mikebrady/shairport-sync).

### Build

```bash
# Build latest version
docker build -t mxtnr/shairport-sync .

# Build other version
docker build --build-arg SHAIRPORT_VERSION=2.8.0 --build-arg ALAC_VERSION=0.0.7 -t knapoc/shairport-sync:2.8.0 .
```

### Run

```bash
docker run -d \
    --name=container_name
    --net=host \
    --device=/dev/snd:/dev/snd \
    -v "/path/to/your/shairport-sync.conf:/usr/local/etc/shairport-sync.conf" \
    knapoc/shairport-sync
```

### Compose

```yaml
  version: '2'
  services:
    shairportSync:
      restart: always
      image: mxtnr/shairport-sync
      network_mode: host
      volumes:
        - "/etc/localtime:/etc/localtime:ro"
        - "/path/to/your/shairport-sync.conf:/usr/local/etc/shairport-sync.conf"
      devices:
        - "/dev/snd:/dev/snd"
```

### Parameters

* `--net=host` **must** be run in host mode
* `--device=/dev/snd:/dev/snd` share host alsa system with container. Does not require `--privileged` as `-v /dev/snd:/dev/snd` would
* `-v "/path/to/your/shairport-sync.conf:/usr/local/etc/shairport-sync.conf"` (optional) - your own shairport-sync.conf file. A [default config file](https://github.com/knapoc/shairport-sync/blob/master/shairport-sync.conf) is being copied during the build process.

### Dockerfile defines some shairport-sync compilation arguments
  * `--with-alsa` # output_backend
  * `--with-pipe` # optional output_backend to enable raw audio to be output through a unix pipe
  * `--with-avahi` # mdns_backend
  * `--with-ssl=openssl` # for encryption and related utilities
  * `--with-metadata` # to add support for Shairport Sync to pipe metadata to a compatible application of your choice
  * `--with-apple-alac` # to include the Apple ALAC Decoder.
