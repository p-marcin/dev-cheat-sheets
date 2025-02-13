#!/bin/bash
# GENERATES SITE (USED BY GITHUB WORKFLOW)

npx antora generate --fetch --clean "${@}" "antora-playbook.yml"
