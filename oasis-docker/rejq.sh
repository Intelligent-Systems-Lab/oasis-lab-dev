if [ -z "$1" ]
then
    echo "File not found."
else
    echo "JSON formatter : $1 "
    jq . $1 > /tmp/tmp.json
    cp /tmp/tmp.json $1
fi


