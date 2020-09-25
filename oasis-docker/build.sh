#docker build -t tony92151/oasis-docker -f ./$1/Dockerfile

if [ -z "$1" ]
then
      echo -e "Build from current folder.\n"
      sleep 2
      docker build -t tony92151/oasis-docker .
else
      echo -e "Build from folder : $1 \n"
      sleep 2
      docker build -f ./$1/Dockerfile -t tony92151/oasis-docker .
fi
