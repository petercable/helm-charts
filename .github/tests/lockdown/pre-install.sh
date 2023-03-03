#!/bin/bash
kubectl label namespace "$VALUES" pod-security.kubernetes.io/enforce=privileged
kubectl create namespace "${VALUES}-deps"
kubectl label namespace "${VALUES}-deps" pod-security.kubernetes.io/enforce=restricted
