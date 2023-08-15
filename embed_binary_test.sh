#!/bin/bash

sed "1,/^\#\#\/\*\*__PAYLOAD_BEGINS__\*\*\/\#\#$/ d" $0 | base64 -d | gzip -d -c > embed_binary_test_output

exit 0
##/**__PAYLOAD_BEGINS__**/##
