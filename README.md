# Prerequisites

* Kubernetes Cluster
  * Cert Manager
  * OTEL Operator (0.43)
  * OTEL Collector
  * OTEL Instr

  ```
  helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace  --version v1.13.2 --set installCRDs=true

  helm install opentelemetry-operator open-telemetry/opentelemetry-operator --namespace opentelemetry --create-namespace --set admissionWebhooks.certManager.create=true

  kubectl apply -f resources.yaml
  ```

# Build

```
docker build -t repro .
```

# Deploy

```
kubectl apply -f pod.yaml
```

# Results

```
kubectl logs autoinstrumentationrepro
```





