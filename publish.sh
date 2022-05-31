#!/bin/bash
#
# I publish the content
#
VOSKCOINTALK_USERNAME="killtheplanet"


if [ -z $VOSKCOINTALK_APIKEY ] ; then
	echo I need VOSKCOINTALK_APIKEY defined or I shall not work
	exit 1
fi

function generate_json () {
	# Pre&Post - better than sedding this together
	echo '{"post":{"raw": "' > part1
	git_text=`git log -1 --pretty=%B | tr '\n' ' '`
	git_hash=`git log --pretty=format:'%h' -n 1`
	echo '", "edit_reason": "${git_hash}: ${git_text}"}}' > part2
}

function generate_toc () {
	cat $@ | hypertoc --make_toc --ol_num_levels 4 --toc_only --toc_entry "H1=1" --toc_end "H1=/H1" --toc_entry "H2=2" --toc_end "H2=/H2" --toc_entry "H3=3" --toc_end "H3=/H3" --toc_entry "H4=4" --toc_end "H4=/H4" 2>/dev/null - > toc.tmp
	# Yes lets hardcode the url....
	cat toc.tmp  | grep -v 'NOTOC'  | sed s/-#heading/https:\\/\\/voskcointalk.com\\/t\\/helium-hnt-hotspot-mining-wiki-faq\\/14786#heading/g > toc.html
}

function generate_payload_content () {
	cat $@ | awk '{printf "%s\\n", $0}' | sed 's/\"/\\"/g' > payload_content
}

function generate_payload () {
	cat part1 payload_content part2 | tr '\n' ' ' > payload
}

function upload_payload () {
	echo Re-Publishing post ${2}
	curl -X PUT https://voskcointalk.com/posts/${1}.json -H "Content-Type: application/json;" -H "Api-Key: ${VOSKCOINTALK_APIKEY}"  -H "Api-Username: ${VOSKCOINTALK_USERNAME}"	--data-binary "@${2}" > /dev/null
	echo Re-publish completed with RC=$?
}


# MAIN
generate_json
generate_toc part01-main.txt part02-faq.txt
generate_payload_content toc.html part01-main.txt 
generate_payload
upload_payload 32319 payload
generate_payload_content part02-faq.txt
generate_payload
upload_payload 47936 payload

# Rubbish cleanup
rm part1 part2 toc.tmp toc.html payload_content payload 2>/dev/null




