#!/bin/bash

 

if [ $# -eq 1 ]

  then

    # labels.component

    yq write -i $1 labels.component java

    # vault.enabled

    yq write -i $1 vault.enabled true

    yq delete -i $1 vault.enable

    # vault.cluster.name

    if [[ $(cat $1 | yq r -  cluster.name) != "null" ]]; then

      yq write -i $1 vault.cluster.name $(cat $1 | yq r - cluster.name)

    fi

    yq delete -i $1 cluster

    # appli.port

    if [[ $(cat $1 | yq r -  containerPort) != "null" ]]; then

      yq write -i $1 appli.port $(cat $1 | yq r - containerPort)

    fi

    yq delete -i $1 containerPort

    # appli.probes.enabled

    yq write -i $1 appli.probes.enabled true

    # appli.livenessProbe

    if [[ $(cat $1 | yq r -  livenessProbe) != "null" ]]; then

      yq write -i $1 appli.livenessProbe.httpGet.path $(cat $1 | yq r - livenessProbe.httpGet.path)

      yq write -i $1 appli.livenessProbe.httpGet.port $(cat $1 | yq r - livenessProbe.httpGet.port)

      yq write -i $1 appli.livenessProbe.httpGet.scheme $(cat $1 | yq r - livenessProbe.httpGet.scheme)

      yq write -i $1 appli.livenessProbe.initialDelaySeconds $(cat $1 | yq r - livenessProbe.initialDelaySeconds)

      yq write -i $1 appli.livenessProbe.periodSeconds $(cat $1 | yq r - livenessProbe.periodSeconds)

    fi

    yq delete -i $1 livenessProbe

    # appli.readinessProbe

    if [[ $(cat $1 | yq r -  readinessProbe) != "null" ]]; then

      yq write -i $1 appli.readinessProbe.httpGet.path $(cat $1 | yq r - readinessProbe.httpGet.path)

      yq write -i $1 appli.readinessProbe.httpGet.port $(cat $1 | yq r - readinessProbe.httpGet.port)

      yq write -i $1 appli.readinessProbe.httpGet.scheme $(cat $1 | yq r - readinessProbe.httpGet.scheme)

      yq write -i $1 appli.readinessProbe.initialDelaySeconds $(cat $1 | yq r - readinessProbe.initialDelaySeconds)

      yq write -i $1 appli.readinessProbe.periodSeconds $(cat $1 | yq r - readinessProbe.periodSeconds)

    fi

    yq delete -i $1 readinessProbe

    # appli.resources

    if [[ $(cat $1 | yq r -  resources) != "null" ]]; then

      yq write -i $1 appli.resources.requests.cpu $(cat $1 | yq r - resources.requests.cpu)

      yq write -i $1 appli.resources.requests.memory $(cat $1 | yq r - resources.requests.memory)

    fi

    yq delete -i $1 resources

    # appli.securityContext

    if [[ $(cat $1 | yq r -  securityContext) != "null" ]]; then

      yq write -i $1 appli.securityContext.runAsUser $(cat $1 | yq r - securityContext.runAsUser)

    fi

    yq delete -i $1 securityContext

    # print final file

    yq read $1

    # print warnings if file needs to be manually updated

    if [[ $(cat $1 | yq r -  lifecycle) != "null" ]]; then

      echo "WARNING: lifecycle detected => you have to manually update values file"

    fi

    if [[ $(cat $1 | yq r -  startupProbe) != "null" ]]; then

      echo "WARNING: startupProbe detected => you have to manually update values file"

    fi

    if [[ $(cat $1 | yq r -  image.pullPolicy) != "null" ]]; then

      echo "WARNING: image.pullPolicy detected => you have to manually update values file"

    fi

    if [[ $(cat $1 | yq r -  emptyDir) != "null" ]]; then

      echo "WARNING: emptyDir detected => you have to manually update values file"

    fi

    if [[ $(cat $1 | yq r -  sidecar.globalConfig) != "null" ]]; then

      echo "WARNING: sidecar.globalConfig detected => you have to manually update values file"

    fi

    if [[ $(cat $1 | yq r -  sidecar.customConfig) != "null" ]]; then

      echo "WARNING: sidecar.customConfig detected => you have to manually update values file"

    fi

else

  echo "Usage: spring2backend.sh <my-values-config-stable-file.yaml>"

  exit 1

fi