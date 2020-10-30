#!/bin/bash

timestamp=$(date +%Y%m%d_%H%M%S)
log_path="`pwd`"
filename=docker_cleanup_$timestamp.log
log=$log_path/$filename


docker_space_before(){
CURRENTSPACE=`docker system df`
echo "Current Docker Space:" >> $log
echo $CURRENTSPACE >>$log
}
docker_find (){
echo "#####################################################################" >> $log
echo "Finding images" >> $log
echo "#####################################################################" >> $log
REMOVEIMAGES=`docker images | grep " [days|months|weeks]* ago" | awk '{print $3}'`

echo "Listing images that needs to be cleaned up" >> $log
echo $REMOVEIMAGES >>$log

}

docker_cleanup(){
echo "#####################################################################" >> $log
echo "Cleaning images" >> $log
echo "#####################################################################" >> $log
docker rmi ${REMOVEIMAGES}
}

docker_space_after(){
CURRENTSPACE=`docker system df`
echo "Current Docker Space, after clean up:" >> $log
echo $CURRENTSPACE >>$log
}
docker_space_before
docker_find
docker_cleanup
docker_space_after