SHELL := /bin/bash
.PHONY: all venv run clean

# set variables
include .env
export
VENV := .venv


# default target, when make executed without arguments
all: venv

$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	./$(VENV)/bin/pip install -r requirements.txt

# venv is a shortcut target
venv: $(VENV)/bin/activate

clean:
	rm -rf $(VENV)
	find . -type f -name '*.pyc' -delete

build: venv
	source $(VENV)/bin/activate && cdk synth

diff: venv
	source $(VENV)/bin/activate && cdk diff

deploy: venv
	source $(VENV)/bin/activate && cdk deploy

sync: venv
	aws s3 sync $(LOCAL_SAVES_DIR) s3://$(BUCKET_NAME)
	aws s3 sync s3://$(BUCKET_NAME) $(LOCAL_SAVES_DIR)