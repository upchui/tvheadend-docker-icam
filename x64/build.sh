rm -rf docker-tvheadend
git clone https://github.com/linuxserver/docker-tvheadend.git
mkdir docker-tvheadend/patches/argtable
mkdir docker-tvheadend/patches/libdvbcsa
mkdir docker-tvheadend/patches/tvheadend
mv docker-tvheadend/patches/config.guess docker-tvheadend/patches/argtable/
mv docker-tvheadend/patches/config.sub docker-tvheadend/patches/argtable/
cp files/libdvbcsa.patch docker-tvheadend/patches/libdvbcsa/
cp files/tvheadend43.patch docker-tvheadend/patches/tvheadend/
cp files/10-adduser docker-tvheadend/
cat files/docker > docker-tvheadend/Dockerfile
cat files/metric_heartbeat.sh > docker-tvheadend/metric_heartbeat.sh
cd docker-tvheadend/
docker build -t thealhu/tvheadend-x64 --network host --no-cache .
