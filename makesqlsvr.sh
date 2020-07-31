#!/usr/bin/env bash

if [ "$1" == "-h" ]
then
    echo "Usage: `basename $0` [instance_name] [forward_port] [sa_password]"
    echo ""
    echo "   instance_name   SQL Server instance name"
    echo "                   (defaults to sqlserver)"
    echo "   forward_port    Local port to which container's 1433 is forwarded"
    echo "                   (defaults to 11433)"
    echo "   sa_password     SQL Server SA password"
    echo "                   (defaults to SqlDockerSA12345)"
    exit 0
fi

INSTANCE_NAME="${1:-sqlserver}"
PORT_FORWARD="${2:-11433}"
SA_PASSWORD="${3:-SqlDockerSA12345}"

container_exists="`docker container list --filter name=${INSTANCE_NAME} | wc -l`"
if [ "${container_exists}" == "1" ]
then
    echo "Running docker container for ${INSTANCE_NAME} on port ${PORT_FORWARD}..."
    echo "SA password is: ${SA_PASSWORD}"
    
    sudo docker run \
        -e "ACCEPT_EULA=Y" \
        -e "SA_PASSWORD=${SA_PASSWORD}" \
        -p ${PORT_FORWARD}:1433 \
        --name ${INSTANCE_NAME} \
        -d mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04
else
    echo "Container ${INSTANCE_NAME} already exists. Skipping creation."
fi
exit 0

