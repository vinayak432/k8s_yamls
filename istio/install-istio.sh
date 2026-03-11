#!/bin/bash
# ============================================================
# Istio Installation via Helm Charts (Hybrid Method)
# Kubernetes 1.33 | Istio 1.22.1
# NOTE:
#   - istio/base and istiod are installed via Helm
#   - ingress gateway is installed via YAML (because istio/gateway Helm chart
#     is failing in this environment)
# ============================================================
set -euo pipefail

ISTIO_NAMESPACE="istio-system"
ISTIO_VERSION="1.22.1"

echo "======================================================"
echo "  Installing Istio ${ISTIO_VERSION} (Hybrid Method)"
echo "======================================================"

# -------------------------------------------------------
# STEP 1 — Add & update the Istio Helm repo
# -------------------------------------------------------
echo ""
echo "[1/6] Adding Istio Helm repository..."
helm repo add istio https://istio-release.storage.googleapis.com/charts || true
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
# -------------------------------------------------------
echo ""
echo "[3/6] Installing istio-base (CRDs)..."
helm upgrade --install istio-base istio/base \
  --namespace ${ISTIO_NAMESPACE} \
  --version ${ISTIO_VERSION} \
  --set defaultRevision=default \
  --wait

echo "CRDs installed:"
kubectl get crd | grep istio.io || true

# -------------------------------------------------------
# STEP 4 — Install istiod (Control Plane)
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
# STEP 5 — Install Istio Ingress Gateway via YAML
#   (Helm chart istio/gateway is broken in this environment)
# -------------------------------------------------------
echo ""
echo "[5/6] Installing Istio Ingress Gateway via YAML..."

kubectl create namespace istio-ingress --dry-run=client -o yaml | kubectl apply -f -

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: istio-ingressgateway-service-account
  namespace: istio-ingress
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: istio-ingressgateway
  namespace: istio-ingress
  labels:
    app: istio-ingressgateway
    istio: ingressgateway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: istio-ingressgateway
      istio: ingressgateway
  template:
    metadata:
      labels:
        app: istio-ingressgateway
        istio: ingressgateway
      annotations:
        sidecar.istio.io/inject: "false"
    spec:
      serviceAccountName: istio-ingressgateway-service-account
      containers:
      - name: istio-proxy
        image: docker.io/istio/proxyv2:${ISTIO_VERSION}
        args:
        - proxy
        - router
        - --domain
        - \$(POD_NAMESPACE).svc.cluster.local
        - --proxyLogLevel=warning
        - --proxyComponentLogLevel=misc:error
        - --log_output_level=default:info
        env:
        - name: JWT_POLICY
          value: third-party-jwt
        - name: PILOT_CERT_PROVIDER
          value: istiod
        - name: CA_ADDR
          value: istiod.istio-system.svc:15012
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: INSTANCE_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: HOST_IP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: PROXY_CONFIG
          value: |
            {"discoveryAddress":"istiod.istio-system.svc:15012"}
        ports:
        - containerPort: 15021
          name: status-port
        - containerPort: 80
          name: http2
        - containerPort: 443
          name: https
        - containerPort: 15090
          name: http-envoy-prom
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
---
apiVersion: v1
kind: Service
metadata:
  name: istio-ingressgateway
  namespace: istio-ingress
spec:
  type: LoadBalancer
  selector:
    app: istio-ingressgateway
    istio: ingressgateway
  ports:
  - name: status-port
    port: 15021
    targetPort: 15021
  - name: http2
    port: 80
    targetPort: 80
  - name: https
    port: 443
    targetPort: 443
EOF

# Wait a bit and show status
sleep 5
kubectl get pods -n istio-ingress
kubectl get svc -n istio-ingress

# -------------------------------------------------------
# STEP 6 — Verify
# -------------------------------------------------------
echo ""
echo "[6/6] Verifying installation..."
echo ""
echo "--- Helm Releases ---"
helm list -n ${ISTIO_NAMESPACE}

echo ""
echo "--- Pods in istio-system ---"
kubectl get pods -n ${ISTIO_NAMESPACE}

echo ""
echo "--- Pods in istio-ingress ---"
kubectl get pods -n istio-ingress

echo ""
echo "--- Ingress Gateway Service ---"
kubectl get svc -n istio-ingress

echo ""
echo "======================================================"
echo "  Istio installed (Hybrid Method)!"
echo ""
echo "  Next steps:"
echo "    kubectl apply -f jenkins-namespace.yaml"
echo "    kubectl apply -f jenkins-istio-deployment-svc.yaml"
echo "    kubectl apply -f gateway.yaml"
echo "    kubectl apply -f gateway-vs.yaml"
echo "======================================================"
