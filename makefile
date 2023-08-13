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

setup-windows:
	echo "TODO"

setup-mac: requirements.txt venv
	python3 -m venv .venv
	source .venv/bin/activate && pip install -r requirements.txt

deploy:
	cdk deploy

diff:
	cdk diff