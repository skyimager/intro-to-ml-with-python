SHELL := $(shell which bash)
LATEST_GIT_COMMIT := $(shell git log -1 --format=%h)
TIME := `/bin/date "+%Y-%m-%d-%H-%M-%S"`
USER?='pradip'

RUN_OS := LINUX
ifeq ($(OS),Windows_NT)
	RUN_OS = WIN32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		RUN_OS = LINUX
	endif
	ifeq ($(UNAME_S),Darwin)
		RUN_OS = OSX
	endif
endif

install:
	pip install -U pip
	pip install --no-cache-dir -r requirements.txt
	pip install jupyter
	pip install jupyter_contrib_nbextensions
	jupyter contrib nbextension install --user

find_python:
	ps -ef | grep python

clean:
	-rm -rf ./**/.ipynb_checkpoints
	-rm -rf ./**/.pyc

STEM?=$(USER)_ML
TAG?=latest
IMAGE:= $(STEM):$(TAG)
DOCKER_FILE=Dockerfile
GPU?='4,5'
dbuild:
	@echo "CREATING DOCKER IMAGE WITH NAME:" $(IMAGE)
	docker build -f $(DOCKER_FILE) \
				 -t $(IMAGE) .

CONTAINER_NAME?=$(USER)_ML_exp
NB_PORT?= 8893
drun:
	@echo "CREATING DOCKER CONTAINER WITH NAME:" $(CONTAINER_NAME)
	@echo "USING DOCKER IMAGE WITH TAG:" $(IMAGE)
	docker run -i -t --rm \
					 -v ${PWD}:/work \
					 -p $(NB_PORT):$(NB_PORT) \
					 --name ${CONTAINER_NAME} \
					 $(IMAGE) /bin/bash

docker_enter:
	docker exec -it ${CONTAINER_NAME} /bin/bash

docker_clean:
	docker rmi $(docker images --filter "dangling=true" -q --no-trunc) 2>/dev/null

jupyter:
	rm -rf nohup.out
	nohup jupyter notebook --port $(NB_PORT) --ip=* --no-browser --allow-root &
	sleep 5
	jupyter notebook list

jupyter-stop:
	jupyter notebook stop $(NB_PORT)