#!/bin/bash
#
# Just my internal publishing process...
#
echo Enter commit update text:
read commit
git commit -a -m "${commit}"
echo Publishing to VoskCoinTalk...
./publish.sh
echo Pushing to Github
git push
echo DONE
