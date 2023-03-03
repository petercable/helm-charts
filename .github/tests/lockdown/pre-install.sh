#!/bin/bash
kubectl label namespace "$VALUES" pod-security.kubernetes.io/enforce=restricted
kubectl create namespace "${VALUES}-system"
kubectl label namespace "${VALUES}-system" pod-security.kubernetes.io/enforce=privileged
