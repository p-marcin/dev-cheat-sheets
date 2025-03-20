#!/bin/bash
# ADDS NEW MODULE

set -o errexit  # ABORT ON NON-ZERO EXIT STATUS
set -o pipefail # DON'T HIDE ERRORS WITHIN PIPES

readonly STEP="[\e[1;96mSTEP\e[0m] \e[1;96m*-*-*-*-*-*-*\e[0m"
readonly ERROR="[\e[1;31mERROR\e[0m]"

usage() {
  cat << EOF
Usage: ${0} [new-module]

Adds new module

OPTIONS:
  -g                     General module with committed category logo

Examples:
  # Add new "brand" module
  ${0} "brand"

  # Add new "general" module
  ${0} -g "general"
EOF
  exit 1
}

categoryLogo="image:https://www.vectorlogo.zone/logos/awesome-emoji/awesome-emoji-icon.svg[role=category-logo]"

while getopts ":hg" option; do
  case "${option}" in
    g) categoryLogo="pass:a[<span class=\"image category-logo\"><img src=\"{site-url}/reference/{imagesdir}/duke.svg\"></span>]" ;;
    h|?) usage ;;
  esac
done

shift $((OPTIND - 1))
newModule="${1,,}"
newModulePath="../docs/modules/${newModule}"

[[ -z "${newModule}" ]] && usage

if [[ -d "${newModulePath}" ]]; then
  echo -e "${ERROR} The \"${newModule}\" module already exists. Pick different name"; exit 1
fi

main() {
  createModuleSubDirs
  createModuleNav
  createModuleIndex
  addModuleToNavs
}

createModuleSubDirs() {
  echo -e "${STEP} Create Module Subdirectories"
  mkdir -p "${newModulePath}/images" "${newModulePath}/pages" "${newModulePath}/partials"
}

createModuleNav() {
  echo -e "${STEP} Create Module Navigation"
  cat <<EOF > "${newModulePath}/nav.adoc"
* xref:${newModule}:index.adoc[]
EOF
  ln -s ../nav.adoc "${newModulePath}/partials/nav.adoc"
}

createModuleIndex() {
  echo -e "${STEP} Create Module Index Page"
  local newModuleTitle=$(echo "${newModule//-/ }" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
  cat <<EOF > "${newModulePath}/pages/index.adoc"
= ${categoryLogo} ${newModuleTitle}

image:https://img.shields.io/badge/Documentation-2088E9?logo=quickLook&logoColor[link="https://example.com",window=_blank]

include::${newModule}:partial\$nav.adoc[lines=2..-1]

== Overview

Write here...

EOF
}

addModuleToNavs() {
  echo -e "${STEP} Add Module to Navigations"
  local rootIndex="../docs/modules/ROOT/pages/index.adoc"
  local lineOfLastModule="$(grep -n 'end::resources' "${rootIndex}" | tail -n1 | cut -d: -f1)"
  sed -i "${lineOfLastModule}i include::${newModule}:partial\$nav.adoc[]" "${rootIndex}"

  local antoraYml="../docs/antora.yml"
  local lineOfLastModule="$(grep -n '\- modules' "${antoraYml}" | tail -n1 | cut -d: -f1)"
  sed -i "${lineOfLastModule}a \ \ - modules/${newModule}/nav.adoc" "${antoraYml}"
}

main
