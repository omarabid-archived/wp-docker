#!/bin/bash

case "$1" in
	configure-server)
		echo "Creating a SWAP file"
		dd if=/dev/zero of=/swapfile1 bs=1024 count=1024288
		chown root:root /swapfile1
		chmod 0600 /swapfile1
		mkswap /swapfile1
		swapon /swapfile1
		echo "Installing Docker components"
		mkdir -p /opt/bin	
		curl -L https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /opt/bin/docker-compose
		chmod +x /opt/bin/docker-compose
		sudo -u core docker-compose -v
		echo "======="
		echo "Everything seems to be going fine!"	
		;;
	build)
		echo "Building your Virtual Environment $2"
		docker-compose -p "$2" build
		;;
	run)
		echo "Running your Virtual Environment $2"
		nohup docker-compose -p "$2" up &
		;;
	stop)
		echo "Stopping your Virtual Environment $2"
		docker-compose -p "$2" kill 
		;;
	destroy)
		echo "Destroying Docker Containers for $2"
		docker-compose -p "$2" rm
		;;
	reset)
		sudo git pull origin master
		./script.sh stop "$2"
		./script.sh destroy "$2"
		./script.sh build "$2"
		./script.sh run "$2"
		;;
	backup)
		docker exec backup backup
		;;
	restore)	
		docker exec backup restore $2
		;;
esac
