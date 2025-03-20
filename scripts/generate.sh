#!/bin/bash
# GENERATES SITE (USED BY GITHUB WORKFLOW)

SITE_SEARCH_PROVIDER=docsearch npx antora generate --fetch --clean "${@}" "antora-playbook.yml"
