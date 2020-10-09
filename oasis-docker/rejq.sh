echo "JSON formatter : $1 "
jq . $1 > /tmp/tmp.json
cp /tmp/tmp.json $1