#!/usr/bin/env bash

source $(dirname ${BASH_SOURCE[0]})/setenv.sh

# find deploying one
pod=$(kubectl get pods --kubeconfig ${KUBE_CONFIG} --namespace ${NAMESPACE} \
  | grep "${PROJECT_NAME}" | grep "1/2" | awk -F' ' '{print $1}' | head -1)

if [[ -z "${pod}" ]]; then
  # find anyone
  pod=$(kubectl get pods --kubeconfig ${KUBE_CONFIG} --namespace ${NAMESPACE} \
    | grep "${PROJECT_NAME}" | awk -F' ' '{print $1}' | head -1)
fi

test -n "${pod}" || die "ERROR: Failed to find app pod!"

echo "Found ${pod}"

kubectl exec --kubeconfig ${KUBE_CONFIG} --namespace ${NAMESPACE} \
  -it ${pod} -- /bin/bash