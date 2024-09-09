
PROJECT := charcoal-light
ACTIVATE := source $(HOME)/.venv/$(PROJECT)/bin/activate
SHELL := bash -u -e -o pipefail

all: test

SD := ../SmokeDetector

TEXT_FILES := \
 bad_keywords.txt \
 watched_keywords.txt \
 blacklisted_websites.txt \
 blacklisted_usernames.txt \
 blacklisted_numbers.txt \
 watched_numbers.txt \
 blacklisted_nses.yml \
 watched_nses.yml \
 blacklisted_cidrs.yml \
 watched_cidrs.yml \
 watched_asns.yml \

ENV := env PYTHONPATH=.:$(SD)  # :$(SD)/test
PYTEST := $(ENV) pytest --capture=tee-sys

test: config.ci $(TEXT_FILES)
	$(ACTIVATE) && $(PYTEST) test/test_vector.py

config.ci: $(SD)/config.ci
	cp $< $@

%.txt:
	cp $(SD)/$@ $@
%.yml:
	cp $(SD)/$@ $@

STRICT := --strict --warn-unreachable --ignore-missing-imports --no-namespace-packages

ruff-check:
	$(ACTIVATE) && black . && isort . && ruff check
lint: ruff-check
	$(ACTIVATE) && pyright .
	$(ACTIVATE) && mypy $(STRICT) .

install: $(SD) $(HOME)/.venv/$(PROJECT)/bin/activate
	$(ACTIVATE) && pip install -r requirements.txt --upgrade
	$(ACTIVATE) && pre-commit install

$(HOME)/.venv/$(PROJECT)/bin/activate:
	python -m venv $(HOME)/.venv/$(PROJECT)

URL := https://github.com/Charcoal-SE/SmokeDetector/archive/refs/heads/deploy.zip
TEMP := /tmp/$(shell basename $(URL))

$(SD):
	curl -o $(TEMP) -s -L $(URL)
	cd .. && unzip $(TEMP)
	mv ../SmokeDetector-deploy $@
	# Fits within 5 Mib, which is significantly less than 1.3 Gib.
	du -sk $@

clean:
	rm -f $(TEMP) $(HOME)/.venv/$(PROJECT)

.PHONY: all test ruff-check lint install clean
