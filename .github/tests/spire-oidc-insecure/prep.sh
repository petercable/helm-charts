#!/bin/bash
helm install ingress-nginx ingress-nginx --version 4.5.2 --repo https://kubernetes.github.io/ingress-nginx -n "$VALUES"
kubectl wait --namespace ingress-nginx   --for=condition=ready pod   --selector=app.kubernetes.io/component=controller -n "$VALUES"
