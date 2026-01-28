#!/bin/bash

set -euo pipefail

echo -e "\n🐘 Installing PostgreSQL (for Keycloak)...\n"

helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update

# Install/upgrade PostgreSQL. Force a known-working image repository/tag for this tutorial setup.
helm upgrade --install polar-keycloak-postgresql bitnami/postgresql \
  -n keycloak-system --create-namespace \
  --set image.registry=docker.io \
  --set image.repository=bitnamilegacy/postgresql \
  --set image.tag=17.6.0-debian-12-r0 \
  --set auth.username=keycloak \
  --set auth.password=keycloakpassword \
  --set auth.database=keycloak

echo -e "\n⌛ Waiting for PostgreSQL to be ready...\n"
kubectl wait \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/instance=polar-keycloak-postgresql \
  --timeout=600s \
  --namespace=keycloak-system

echo -e "\n🗝️  Keycloak deployment started.\n"

echo "🔐 Generating Keycloak client secret..."
clientSecret=$(echo $RANDOM | openssl md5 | head -c 20)

kubectl apply -f resources/namespace.yaml
sed "s/polar-keycloak-secret/$clientSecret/" resources/keycloak-config.yaml | kubectl apply -n keycloak-system -f -

echo -e "\n📦 Configuring Helm chart..."

helm repo add codecentric https://codecentric.github.io/helm-charts
helm repo update

helm upgrade --install polar-keycloak codecentric/keycloakx \
  --values values-codecentric.yaml \
  --namespace keycloak-system \
  --version 7.1.5

echo -e "\n⌛ Waiting for Keycloak to be deployed..."

kubectl rollout status statefulset/polar-keycloak -n keycloak-system --timeout=600s


echo -e "\n⌛ Waiting for Keycloak to be ready..."

kubectl wait --for=condition=ready pod \
  --selector=statefulset.kubernetes.io/pod-name=polar-keycloak-0 \
  --timeout=600s -n keycloak-system

echo -e "\n✅  Keycloak cluster has been successfully deployed."

echo -e "\n🔐 Your Keycloak Admin credentials:"
echo "Admin Username: user"
echo "Admin Password: RoAObTLLiAXRzkjWhyQf"

echo -e "\n🔑 Generating Secret with Keycloak client secret."

kubectl delete secret polar-keycloak-client-credentials -n keycloak-system || true

kubectl create secret generic polar-keycloak-client-credentials \
    --from-literal=spring.security.oauth2.client.registration.keycloak.client-secret="$clientSecret" \
    -n keycloak-system

echo -e "\n🍃 'polar-keycloak-client-credentials' has been created for Spring Boot applications to interact with Keycloak."

echo -e "\n🗝️  Keycloak deployment completed.\n"
