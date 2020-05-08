build:
	docker build -t mxtnr/shairport-sync .

run:
	docker run -d --net=host  --device=/dev/snd:/dev/snd -v "/home/pi/services/airplay/shairport-sync.conf:/usr/local/etc/shairport-sync.conf"  mxtnr/shairport-sync
