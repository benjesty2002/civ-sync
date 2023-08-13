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

build: $(VENV)/bin/activate
	source $(VENV)/bin/activate && cdk synth

diff: $(VENV)/bin/activate
	source $(VENV)/bin/activate && cdk diff

deploy: $(VENV)/bin/activate
	source $(VENV)/bin/activate && cdk deploy

sync:
	aws s3 sync $(LOCAL_SAVES_DIR) s3://$(BUCKET_NAME)
	aws s3 sync s3://$(BUCKET_NAME) $(LOCAL_SAVES_DIR)