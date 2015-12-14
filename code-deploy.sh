#!/bin/sh
# Proper header for a Bash script.
LOCALJAR=target/yournewtech-0.0.1-SNAPSHOT.war
REMOTEJAR=/var/yournewtech/yournewtech-update-$(date +%Y-%m-%d-%H-%M).war
EXECUTABLEJAR=/var/yournewtech/yournewtech.war
NODE1=prod.yournew.tech
USER=root
SERVICE=yournewtech

abort()
{
    echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred. Exiting..." >&2
    exit 1
}

build()
{
    echo "Starting Maven Build"
    mvn -Pprod package
}

upload()
{
    echo "Starting upload to $1"
    scp $LOCALJAR $USER@$1:$REMOTEJAR
}

shutdown()
{
    echo "Stopping $SERVICE service on $1"
    if ssh root@$1 service $SERVICE stop;
    then
        echo "Waiting 20 seconds for $1 to stop"
        sleep 20
    else
        echo "Continuing..."
    fi
}

update()
{
    echo "Updating executable jar on $1"
    ssh $USER@$1 mv -f $REMOTEJAR $EXECUTABLEJAR
}

startup()
{
    echo "Starting $SERVICE service on $1"
    ssh root@$1 service $SERVICE start
}

#set -e


read -p "Are you sure you want to update and restart DEV servers?" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi


# Add your script below....
# If an error occurs, the abort() function will be called.
#----------------------------------------------------------

trap 'abort' 0


#build

upload $NODE1

shutdown $NODE1
update $NODE1
startup $NODE1


trap 0

echo >&2 '
************
*** DONE *** 
************
'