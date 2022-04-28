#!/usr/bin/env bash

if [ -z $1 ]; then
  echo "Error: version parameter is not set"
  echo "Usage: $0 <version>"
  exit 1
fi

declare version=$1
declare crds=(alertmanagerconfigs alertmanagers podmonitors probes prometheuses prometheusrules servicemonitors thanosrulers)

# Create a directory for the new version
mkdir -p $version || true
cd $version

# Fetch known CRDs for the new version
for crd in ${crds[@]};
  do declare crdpath=https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$version/example/prometheus-operator-crd/monitoring.coreos.com_$crd.yaml && \
    curl -vOL "$crdpath";
done

# Remove status: from the yaml files
for file in *; do
  yq e -i 'del(.status)' $file && \
  yq e -i 'del(.metadata.creationTimestamp)' $file;
done
