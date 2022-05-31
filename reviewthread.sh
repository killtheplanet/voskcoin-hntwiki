#!/bin/bash
#
# I pull a particular thread id
#
VOSKCOINTALK_USERNAME="killtheplanet"


if [ -z $VOSKCOINTALK_APIKEY ] ; then
	echo I need VOSKCOINTALK_APIKEY defined or I shall not work
	exit 1
fi


echo Thread Number?
read thread

curl -X GET https://voskcointalk.com/t/${thread}.json -H "Api-Key: $VOSKCOINTALK_APIKEY"  -H "Api-Username: $VOSKCOINTALK_USERNAME" | jq | less

exit 0




