#!/bin/bash
# GENERATES SITE (USED BY GITHUB WORKFLOW)

export SITE_SEARCH_PROVIDER=docsearch
npx antora generate --fetch --clean "${@}" "antora-playbook.yml"
