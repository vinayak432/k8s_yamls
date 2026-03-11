#!/bin/bash
# ============================================================
# Istio Installation via Helm Charts
# Tested on Kubernetes 1.33 | Istio 1.22.x
# ============================================================
set -euo pipefail

ISTIO_NAMESPACE="istio-system"
ISTIO_VERSION="1.22.1"   # Pin to a specific version for reproducibility

echo "======================================================"
echo "  Installing Istio ${ISTIO_VERSION} via Helm"
echo "======================================================"

# -------------------------------------------------------
# STEP 1 — Add & update the Istio Helm repo
# -------------------------------------------------------
echo ""
echo "[1/6] Adding Istio Helm repository..."
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

echo "Available Istio charts:"
helm search repo istio/ --versions | head -15

# -------------------------------------------------------
# STEP 2 — Create the istio-system namespace
# -------------------------------------------------------
echo ""
echo "[2/6] Creating namespace: ${ISTIO_NAMESPACE}..."
kubectl create namespace ${ISTIO_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# -------------------------------------------------------
# STEP 3 — Install istio-base (CRDs)
#   installs all Istio CRDs: VirtualService, Gateway,
#   DestinationRule, PeerAuthentication, etc.
# -------------------------------------------------------
echo ""
echo "[3/6] Installing istio-base (CRDs)..."
helm upgrade --install istio-base istio/base \
  --namespace ${ISTIO_NAMESPACE} \
  --version ${ISTIO_VERSION} \
  --set defaultRevision=default \
  --wait

echo "CRDs installed:"
kubectl get crd | grep istio.io

# -------------------------------------------------------
# STEP 4 — Install istiod (Control Plane)
#   includes Pilot (xDS server), CA, sidecar injector webhook
# -------------------------------------------------------
echo ""
echo "[4/6] Installing istiod (control plane)..."
helm upgrade --install istiod istio/istiod \
  --namespace ${ISTIO_NAMESPACE} \
  --version ${ISTIO_VERSION} \
  --set pilot.resources.requests.cpu=100m \
  --set pilot.resources.requests.memory=256Mi \
  --set global.proxy.resources.requests.cpu=50m \
  --set global.proxy.resources.requests.memory=64Mi \
  --set meshConfig.accessLogFile=/dev/stdout \
  --set meshConfig.enableTracing=true \
  --wait

kubectl rollout status deployment/istiod -n ${ISTIO_NAMESPACE}

# -------------------------------------------------------
# STEP 5 — Install istio-ingressgateway
#   exposes services externally via LoadBalancer
# -------------------------------------------------------
echo ""
echo "[5/6] Installing Istio Ingress Gateway..."
kubectl create namespace istio-ingress --dry-run=client -o yaml | kubectl apply -f -
#kubectl label namespace istio-ingress istio-injection=enabled --overwrite

helm upgrade --install istio-ingressgateway istio/gateway \
  --namespace istio-ingress \
  --version ${ISTIO_VERSION} \
 # --set service.type=LoadBalancer \
 # --set resources.requests.cpu=100m \
 # --set resources.requests.memory=128Mi \
  --wait

echo "Patching gateway service to LoadBalancer..."
kubectl patch svc istio-ingressgateway -n istio-ingress \
  -p '{"spec":{"type":"LoadBalancer"}}'  


# -------------------------------------------------------
# STEP 6 — Verify
# -------------------------------------------------------
echo ""
echo "[6/6] Verifying installation..."
echo ""
echo "--- Helm Releases ---"
helm list -n ${ISTIO_NAMESPACE}
helm list -n istio-ingress

echo ""
echo "--- Pods in istio-system ---"
kubectl get pods -n ${ISTIO_NAMESPACE}

echo ""
echo "--- Ingress Gateway Service ---"
kubectl get svc -n istio-ingress

echo ""
echo "======================================================"
echo "  Istio installed successfully via Helm!"
echo ""
echo "  Next steps:"
echo "    kubectl apply -f 02-jenkins-namespace.yaml"
echo "    kubectl apply -f 03-jenkins.yaml"
echo "    kubectl apply -f 04-gateway-vs.yaml"
echo "======================================================"

