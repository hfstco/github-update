#!/bin/bash

sudo apt install -y git jq

jq -c '.repos[]' repos.json | while read r; do
        url=$(jq -r '.url' <<< $r);
        repo=${url#*github.com/}
        #user=${repo#*/}
        #name=${repo%/*}

        echo "Updating $url...";

        jq -r '.branches[]' <<< $r | while read b; do
                mkdir -p $repo/$b
                cd $repo/$b
                echo "$PWD"
                git clone --recursive $url .
                git fetch
                git checkout -b $b origin/$b
                git pull
                git show

                #compile
                jq -r '.compile[]' <<< $r | while read c; do
                        $c
                done

                cd ../../..
                echo "$PWD"
        done
done