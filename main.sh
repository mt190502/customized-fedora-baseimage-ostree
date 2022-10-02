#!/bin/bash

if [[ ! -e currdatetime ]]; then
	date +%Y-%m-%d_%H:%M:%S > currdatetime
fi

currdate=$(cat currdatetime)
mkdir -p /tmp/${currdate}

gitrepodirectory=$(pwd)

curl -fsSL 'https://getfedora.org/en/workstation/download/' | sed 's/>/>\n/g' > out.html

stablever="$(cat out.html | grep 'x86_64 Live ISO' | grep div | awk '{print $2}' | tr -d \:)"
betaver="$(cat out.html | grep 'x86_64 Live ISO' | grep span | awk '{print $2}' | tr -d \:)"

case $@ in
	--setup)
		if [[ -n $betaver ]]; then
			./compile.sh $betaver beta
			exit
		fi

		if [[ -n $stablever ]]; then
			./compile.sh $stablever stable
		fi
	;;
	--compress)
		if [[ -n $betaver ]] && [[ -d /tmp/${currdate}/$betaver-beta/repo ]]; then
			tar -czf /tmp/repo.tar.gz -C /tmp/${currdate}/$betaver-beta/repo .
		fi
		if [[ -n $stablever ]] && [[ -d /tmp/${currdate}/$stablever-stable/repo ]]; then
			tar -czf /tmp/repo.tar.gz -C /tmp/${currdate}/$stablever-stable/repo .
		fi
	;;
esac
