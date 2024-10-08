# Aeternity builder image

The images are automatically published to DockerHub [`aeternity/builder`](https://hub.docker.com/r/aeternity/builder/). It is meant to be used as docker base image for aeternity node builds.

Note: We build and install RocksDB as a dynamically loaded library to speed
up aeternity build times. For this to work, `-DWITH_SYSTEM_ROCKSDB=ON` must
be passed when building the erlang-rocksdb bindings. This is set up in the
aeternity Dockerfile. Without this flag, erlang-rocksdb will compile and
link RocksDB statically, which takes a long time.
