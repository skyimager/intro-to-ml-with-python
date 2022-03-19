SHELL := $(shell which bash)
PIP_EXTRA_INDEX_URL := $(shell echo $$PIP_EXTRA_INDEX_URL)
LATEST_GIT_COMMIT := $(shell git log -1 --format=%h)

CONDA_BIN = $(shell which conda)
CONDA_ROOT = $(shell $(CONDA_BIN) info --base)
CONDA_ENV_NAME ?= "edvancer"
CONDA_ENV_PREFIX = $(shell conda env list | grep $(CONDA_ENV_NAME) | sort | awk '{$$1=""; print $$0}' | tr -d '*\| ')
CONDA_ACTIVATE := source $(CONDA_ROOT)/etc/profile.d/conda.sh ; conda activate $(CONDA_ENV_NAME) && PATH=${CONDA_ENV_PREFIX}/bin:${PATH};	

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

guard-env-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

install:
	make install-dev

install-dev:
	$(CONDA_BIN) env update -n $(CONDA_ENV_NAME) -f environment.yml

environment:
	$(CONDA_BIN) remove -n $(CONDA_ENV_NAME) --all -y --force-remove
	$(CONDA_BIN) env update -n $(CONDA_ENV_NAME) -f environment-dev.yml -f environment.yml

export_environment:
	$(CONDA_BIN) env export -n $(CONDA_ENV_NAME) | grep -v "^prefix: \|^name: " > environment-exported.yml
	cat environment-exported.yml

lint_autofix:
	#autopep8 --in-place --recursive --aggressive --aggressive ./
	yapf -i --in-place --recursive --style pep8 --parallel ./
	# yapf -i --in-place --recursive --style google --parallel ./
	# yapf -i --in-place --recursive --style facebook --parallel ./
	@echo "Few linting issues fixed"

jupyter:
	$(CONDA_ACTIVATE) jupyter notebook --no-browser --allow-root