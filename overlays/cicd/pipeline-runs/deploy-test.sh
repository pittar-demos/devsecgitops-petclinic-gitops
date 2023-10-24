#!/bin/bash

SKOPEO_TAGS=$(skopeo list-tags docker://quay.io/pittar/petclinic-demo | jq -c .Tags | tail -c +2 | head -c -2 | tr -d \")

set -f
TAGS=(${SKOPEO_TAGS//,/ })

for i in "${!TAGS[@]}"; do
  if [[ ${TAGS[i]} = sha* ]]; then
    unset 'TAGS[i]'
  fi
  if [[ ${TAGS[i]} == *SNAPSHOT* ]]; then
    unset 'TAGS[i]'
  fi
done

PS3="Select tag: "

select tag in "${TAGS[@]}"; do

    echo "Preparing to deploy $tag"

    tkn pipeline start deploy-to-test \
        --param image_tag="$tag" \
        --workspace name=gitops,claimName=gitops \
        -n petclinic-cicd

    tkn pipeline logs -f deploy-to-test \
        -n petclinic-cicd

    exit 0
done
