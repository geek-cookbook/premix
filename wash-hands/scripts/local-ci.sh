#!/bin/bash

set -e
set -x

find helm-chart -mindepth 1 -maxdepth 1 -type d | while read chart; do
  # Test basic helm syntax
  helm lint $chart

  # Test Kubernetes manifest syntaxes
  rm -rf manifests
  mkdir -p manifests
  helm template $chart --output-dir manifests
  kubeval -d manifests/

  # Unit-test the chart
  # helm unittest -u $chart
done
