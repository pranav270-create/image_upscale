#!/bin/bash


# Get arguments from command line
# It should just be the task name
TASK=$1
# Check if the task name is empty
if [ -z "$TASK" ]
then
    echo "No task name provided, starting up docker to sleep"
    sudo docker compose -f docker/docker-compose.yml up -d
else
    echo "Starting up docker for task $TASK"
    export TASK=$TASK
    sudo docker compose -f docker/docker-compose-task.yml up -d 
fi
