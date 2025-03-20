#!/bin/bash
# GENERATES DOCUMENTATIONS.ADOC

set -o errexit  # ABORT ON NON-ZERO EXIT STATUS
set -o pipefail # DON'T HIDE ERRORS WITHIN PIPES

readonly STEP="[\e[1;96mSTEP\e[0m] \e[1;96m*-*-*-*-*-*-*\e[0m"
readonly WARNING="[\e[1;33mWARNING\e[0m]"
readonly DOCUMENTATIONS_ADOC_PATH="../docs/modules/ROOT/pages/docs.adoc"
readonly ANTORA_YML_PATH="../docs/antora.yml"

readonly KEYWORDS=( "-API-" "AsciiDoc" "AssertJ" "CSS" "ChatGPT" "CLI-" "DevTools" "DriverJS" "ElasticSearch" "FreeMarker" "GitHub" "GNU-" "GraphQL"
  "gRPC" "Hamcrest" "HTML" "HTTP-" "IntelliJ-IDEA" "Jakarta-EE" "JPA-" "JSON-" "JsonPath" "JavaScript" "JBang" "JMeter" "JReleaser" "JUnit"
  "MapStruct" "MongoDB" "MQ-" "NextJS" "REST" "R2DBC" "SQL" "TypeScript" "UI-" "W3Schools" "WebMVC" "XML-" )

readonly API_DOCS_BADGE_PARAMS=("DF7716" "devbox")
readonly DOCS_BADGE_PARAMS=("2088E9" "quickLook")
readonly AWESOME_BADGE_PARAMS=("FC60A8" "awesomelists")
readonly CLOUDFLARE_BADGE_PARAMS=("F38020" "cloudflare")
readonly DOCKER_BADGE_PARAMS=("2496ED" "docker")
readonly GITHUB_BADGE_PARAMS=("181717" "github")
readonly GO_BADGE_PARAMS=("00ADD8" "go")
readonly GOOGLE_FONTS_BADGE_PARAMS=("4285F4" "googlefonts")
readonly HELM_BADGE_PARAMS=("0F1689" "helm")
readonly MAVEN_BADGE_PARAMS=("C71A36" "apachemaven")
readonly REACT_BADGE_PARAMS=("61DAFB" "react" "333333")
readonly RESHOT_BADGE_PARAMS=("FFFFFF" "data:image/svg%2bxml;base64,PHN2ZyB3aWR0aD0iNDYiIGhlaWdodD0iMzMiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHBhdGggZD0iTTQwIDE1LjJjMy43LTEuOCA1LjctNC44IDUuNy04LjIgMC0zLjMtMS42LTUuMy00LjYtNS42bC0uNC0uM2MtMS41LTEuMi00LTEuNC03LS42TDAgOS41djIyLjdsMy41LS45VjMzbDYtMS42di04bDIxLjgtNS43IDQuMiA1LjEgMi4zLS41IDEuMSAxLjMgNy4xLTEuOC02LTYuNnptLTQuMyA3bC01LjMtNi41TDYgMjIuMnY4TC41IDMxLjVWOS44TDM0IDFjMi44LS44IDUtLjYgNi41LjUgMS4yLjkgMS44IDIuNCAxLjggNC40IDAgMy40LTIgNi4yLTUuNiA4aC0uM2w2IDYuNi02LjYgMS43eiIgZmlsbD0iIzAwMCIvPjxwYXRoIGQ9Ik0zNiA2LjFjLS41LS40LTEuMy0uNC0yLjMtLjJMNiAxMy4ydjQuNWwyNy44LTcuM2MxLjgtLjUgMi44LTEuNiAyLjgtMyAwLS41LS4yLTEtLjYtMS4zek0zMy43IDEwTDkuNiAxNi4zdi0xLjdsMjYuNS03YzAgMS0xIDEuOS0yLjQgMi4zeiIgZmlsbD0iIzAwMCIvPjwvc3ZnPg==")
readonly SHIELDS_BADGE_PARAMS=("555555" "shieldsdotio")
readonly SIMPLE_ICONS_BADGE_PARAMS=("97C900" "simpleicons")
readonly SPRING_BADGE_PARAMS=("6DB33F" "spring")
readonly VECTOR_LOGO_ZONE_BADGE_PARAMS=("184D66" "vectorlogozone")

main() {
  createFile
  appendHeader
  appendDocumentationBadges
  applySedScripts
  collapseMultipleEmptyLines
}

createFile() {
  echo -e "${STEP} Create ${DOCUMENTATIONS_ADOC_PATH}"
  : > "${DOCUMENTATIONS_ADOC_PATH}"
}

appendHeader() {
  echo -e "${STEP} Append Header"
  cat << EOF >> "${DOCUMENTATIONS_ADOC_PATH}"
= 📚 Docs

List of all Docs and other useful stuff
EOF
}

appendDocumentationBadges() {
  echo -e "${STEP} Append Documentation Badges"
  local antoraAttributes="$(sed -e "0,/#= Docs =#/d" -e "s/^[[:space:]]\{4\}//" -e "s/: / /" "${ANTORA_YML_PATH}")"
  local output
  while IFS=" " read -r attribute value; do
    case "${attribute}" in
      \#) output+="$(heading "${value}")" ;;
      \##) output+="$(listElement "${value}")" ;;
      \#+) output+="+\n" ;;
      *) local badge="$(badge "${attribute}")"
        if [[ "${badge}" == "ignored" ]]; then
          echo -e "${WARNING} ${attribute} is ignored"
        else
          output+="${badge}"
        fi
        ;;
    esac
  done <<< "${antoraAttributes}"
  echo -e "${output}" >> "${DOCUMENTATIONS_ADOC_PATH}"
}

heading() {
  local value=${1}
  echo "\n== ${value}\n\n"
}

listElement() {
  local value=${1}
  echo "\n${value}::\n"
}

badge() {
  attribute=${1}
  case "${attribute}" in
    json-api-docs|open-api-docs)                                        staticBadge "${attribute}" "${DOCS_BADGE_PARAMS[@]}" ;;
    *-api-docs|*-reference|*-components)                                staticBadge "${attribute}" "${API_DOCS_BADGE_PARAMS[@]}" ;;
    ant-tasks-docs|maven-plugins|maven-cli-options|go-standard-library) staticBadge "${attribute}" "${API_DOCS_BADGE_PARAMS[@]}" ;;
    *-docs)                                                             staticBadge "${attribute}" "${DOCS_BADGE_PARAMS[@]}" ;;
    awesome-*)                                                          staticBadge "${attribute}" "${AWESOME_BADGE_PARAMS[@]}" ;;
    cloudflare-radar)                                                   staticBadge "${attribute}" "${CLOUDFLARE_BADGE_PARAMS[@]}" ;;
    *-docker|docker-hub)                                                staticBadge "${attribute}" "${DOCKER_BADGE_PARAMS[@]}" ;;
    *-github|github-marketplace)                                        staticBadge "${attribute}" "${GITHUB_BADGE_PARAMS[@]}" ;;
    *-go|go-packages)                                                   staticBadge "${attribute}" "${GO_BADGE_PARAMS[@]}" ;;
    google-fonts)                                                       staticBadge "${attribute}" "${GOOGLE_FONTS_BADGE_PARAMS[@]}" ;;
    *-helm|artifact-hub)                                                staticBadge "${attribute}" "${HELM_BADGE_PARAMS[@]}" ;;
    maven-repository)                                                   staticBadge "${attribute}" "${MAVEN_BADGE_PARAMS[@]}" ;;
    react-icons)                                                        staticBadge "${attribute}" "${REACT_BADGE_PARAMS[@]}" ;;
    reshot)                                                             staticBadge "${attribute}" "${RESHOT_BADGE_PARAMS[@]}" ;;
    shields)                                                            staticBadge "${attribute}" "${SHIELDS_BADGE_PARAMS[@]}" ;;
    simple-icons)                                                       staticBadge "${attribute}" "${SIMPLE_ICONS_BADGE_PARAMS[@]}" ;;
    spring-initializr|spring-framework-projects)                        staticBadge "${attribute}" "${SPRING_BADGE_PARAMS[@]}" ;;
    vector-logo-zone)                                                   staticBadge "${attribute}" "${VECTOR_LOGO_ZONE_BADGE_PARAMS[@]}" ;;
    *) echo "ignored" ;;
  esac
}

staticBadge() {
  attribute="${1}"
  backgroundColor="${2}"
  logo="${3}"
  logoColor="${4:-white}"
  title="$(formatTitle "${attribute}")"
  echo "image:https://img.shields.io/badge/${title}-${backgroundColor}?logo=${logo}&logoColor=${logoColor}[link=\"{${attribute}}\",window=_blank]\n"
}

formatTitle() {
  attribute="${1}"
  for keyword in "${KEYWORDS[@]}"; do
    if [[ "${attribute}" == *"${keyword,,}"* ]]; then
      attribute="${attribute//${keyword,,}/${keyword}}"
    fi
  done
  title="$(echo "${attribute//-/ }" | awk '{ for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print }')"
  echo "${title// /%20}"
}

applySedScripts() {
  echo -e "${STEP} Apply Sed Scripts"
  sed -i "s/HamcREST/Hamcrest/" "${DOCUMENTATIONS_ADOC_PATH}"
  sed -i "s/GRPC/gRPC/" "${DOCUMENTATIONS_ADOC_PATH}"
  sed -i "s/RESTtemplate/RestTemplate/" "${DOCUMENTATIONS_ADOC_PATH}"
}

collapseMultipleEmptyLines() {
  echo -e "${STEP} Collapse Multiple Empty Lines"
  sed -i -e "/./,/^$/!d" -e "\$d" "$DOCUMENTATIONS_ADOC_PATH"
}

main
