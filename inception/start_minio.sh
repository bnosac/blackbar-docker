#! /bin/bash

#echo "------- Setting Minio blackbar user ------"
#env
#mc admin config set
#mc admin user add blackbar "blackbar" "blackbar"
#mc admin policy attach ALIAS readwrite --user=blackbar

echo "------- Launching Minio ------"
minio server /data --address ":9900" --console-address ":9901"

