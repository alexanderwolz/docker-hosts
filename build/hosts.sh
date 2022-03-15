#!/bin/bash

source ./common.sh

echo "started hosts script at $(date)"
echo "-------------------------------------------------------"
echo "Initializing running docker containers .."

cleanUpdate

echo "-------------------------------------------------------"
echo "Finished initialization, listening for docker events .."
echo "-------------------------------------------------------"

docker events --filter 'type=network' --filter='event=connect' --filter='event=disconnect' --format 'CONTAINER={{.Actor.Attributes.container}} ACTION={{.Action}} TIME={{.Time}}' \
| while read LINE;
do  
    export $LINE
    NAME=$(docker inspect --format '{{.Name}}' $CONTAINER | cut -c2- )
    echo "Received $ACTION event for $NAME"
    if [[ $ACTION == "connect" ]]; then
        updateHost "$NAME"
    fi
    if [[ $ACTION == "disconnect" ]]; then
        removeHost "$NAME"
        if [ "$?" -ne 0 ]; then
            echo "[Error]: Could not remove entry for '$NAME'!"
        else
            echo "Removed '$NAME' from hosts"
        fi
    fi
done