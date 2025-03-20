#!/bin/bash
# ADDS NEW MODULE

set -o errexit  # ABORT ON NON-ZERO EXIT STATUS
set -o pipefail # DON'T HIDE ERRORS WITHIN PIPES

readonly NEW_MODULE="${1}"

main() {
  validate
  createModuleDirs
  createModuleNav
  createModuleIndex
  addModuleToNavs
}

validate() {
  if [[ -z "${NEW_MODULE}" ]]; then
    echo -e "ERR: Provide module name as a parameter, e.g.\n\t${0} \"java-example\""; exit 1
  fi
  newModulePath="../docs/modules/${NEW_MODULE}"
  if [[ -d "${newModulePath}" ]]; then
    echo -e "ERR: The \"${NEW_MODULE}\" module already exists. Pick different name"; exit 1
  fi
}

createModuleDirs() {
  mkdir -p "${newModulePath}/images" "${newModulePath}/pages" "${newModulePath}/partials"
}

createModuleNav() {
  cat <<EOF > "${newModulePath}/nav.adoc"
* xref:${NEW_MODULE}:index.adoc[]
EOF
  ln -s ../nav.adoc "${newModulePath}/partials/nav.adoc"
}

createModuleIndex() {
  local newModuleTitle=$(echo "${NEW_MODULE//-/ }" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
  cat <<EOF > "${newModulePath}/pages/index.adoc"
= 📜 ${newModuleTitle}

image:https://img.shields.io/badge/Documentation-2088E9?logo=quickLook&logoColor[link="https://example.com",window=_blank]

include::${NEW_MODULE}:partial\$nav.adoc[lines=2..-1]

== Overview

Write here...

EOF
}

addModuleToNavs() {
  local rootIndex="../docs/modules/ROOT/pages/index.adoc"
  local lineOfLastModule="$(grep -n 'include::' "${rootIndex}" | tail -n1 | cut -d: -f1)"
  sed -i "${lineOfLastModule}a include::${NEW_MODULE}:partial\$nav.adoc[]" "${rootIndex}"

  local antoraYml="../docs/antora.yml"
  local lineOfLastModule="$(grep -n 'modules' "${antoraYml}" | tail -n1 | cut -d: -f1)"
  sed -i "${lineOfLastModule}a \ \ - modules/${NEW_MODULE}/nav.adoc" "${antoraYml}"
}

main
