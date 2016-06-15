Steps:

__[1] build apt-cacher-ng docker image:__
```bash
$ sudo docker build -t apt-cacher-ng .
```

__[2] create container from the previously built image:__
```bash
$ sudo docker run --detach \
	--name apt-cacher-ng \
	--hostname apt-cacher-ng \
	--publish 3142:3142 \
	--volume ~/docker/volumes/apt-cacher-ng/var/cache/apt-cacher-ng:/var/cache/apt-cacher-ng \
	--volume ~/docker/volumes/apt-cacher-ng/var/log/apt-cacher-ng:/var/log/apt-cacher-ng \
	--restart always \
	apt-cacher-ng
```

__[3] check docker container log to make sure everything is ok:__
```bash
docker logs apt-cacher-ng
```
