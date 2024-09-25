#!/bin/bash
# GENERATES LOCAL SITE

npx antora generate --fetch --clean "${@}" local-playbook.yml
