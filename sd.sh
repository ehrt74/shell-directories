#!/usr/bin/env bash

DATABASE_FILE=`realpath ~/.cd.db`
SD_EXECUTABLE='sd.py'

sda () {
    $SD_EXECUTABLE $DATABASE_FILE add
}

sdl () {
    $SD_EXECUTABLE $DATABASE_FILE list
}

sdc () {
    $SD_EXECUTABLE $DATABASE_FILE clear
}

sdd () {
    $SD_EXECUTABLE $DATABASE_FILE delete $1
}

sdg () {
    cd `$SD_EXECUTABLE $DATABASE_FILE get $1`
}
