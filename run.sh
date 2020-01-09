sudo rm -rf test/.dub
docker build -t dcompute-docker-test .
docker run --gpus all -v $PWD/test:/work dcompute-docker-test bash -c "cd /work && dub"
