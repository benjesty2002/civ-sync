.PHONY: all venv run clean

# define the name of the virtual environment directory
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
