PYTHON_BIN=venv/bin/python
PROJECT=kuttadmin
APP=kutt

.PHONY: init
init:
	mkdir requirements
	echo -n "-r requirements/base.txt">requirements.txt
	touch requirements/base.txt
	touch requirements/develop.txt

.PHONY: init-django
init-django:
	$(PYTHON_BIN) -m pip install django
	$(PYTHON_BIN) -m django-admin startproject ${PROJECT}
	$(PYTHON_BIN) manage.py startapp ${APP}

.PHONY: venv
venv:
	python3.8 -m venv venv
	$(PYTHON_BIN) -m pip install pip --upgrade
	$(PYTHON_BIN) -m pip install -r requirements/develop.txt
	$(PYTHON_BIN) -m pip install -r requirements/base.txt

.PHONY: run-dev
run-dev:
	$(PYTHON_BIN) manage.py runserver 0.0.0.0:8000

.PHONY: secret-key
secret-key:
	$(PYTHON_BIN) -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'

.PHONY: build-base
build-base:
	docker build -t registry.gitlab.com/ugleiton/kutt-admin:base -f Dockerfile-base .

.PHONY: build
build:
	docker build -t registry.gitlab.com/ugleiton/kutt-admin:latest .
