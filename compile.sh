#!/bin/bash

gitrepodirectory=$(pwd)

currdate=$(cat currdatetime)
pushd /tmp/${currdate}

mkdir $1-$2
cd $1-$2

cp $gitrepodirectory/src/* .

for a in $(ls *RELEASEVER*); do 
	sed -i "s|RELEASEVER|$1|g" $a
	mv $a $(echo $a | sed "s/RELEASEVER/$1/g")
done

sed -i "s|RELEASEVER|$1|g" fedora-base.yaml fedora-common-ostree.yaml mt190502-s-environment.yaml
sed -i "s|DATETIME|$(date +%Y-%m-%d_%H-%M-%S)|g" mt190502-s-environment.yaml

mkdir -p repo cache

if [ ! -d repo/objects ]; then
	ostree --repo=repo init --mode=archive || exit
fi

sudo rpm-ostree compose tree --repo=repo --cachedir=cache mt190502-s-environment.yaml
sudo ostree summary --repo=repo --update
