#!/bin/bash
# GENERATES SITE

npx antora generate --fetch --clean "${@}" antora-playbook.yml
