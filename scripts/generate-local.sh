#!/bin/bash
# GENERATES LOCAL SITE

export SITE_SEARCH_PROVIDER=docsearch
npx antora generate --fetch --clean "${@}" "../local-playbook.yml"
