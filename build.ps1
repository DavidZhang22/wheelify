
docker build -t example .
docker run -it  --rm -v ${PWD}/dist://home/ubuntu/dist example
