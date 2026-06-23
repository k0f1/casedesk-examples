# Deploy DeepSeek to AWS EKS

This example deploys DeepSeek R1 to an existing AWS EKS cluster using Kubernetes.

## Prerequisites

- EKS cluster with GPU node group (`g4dn.xlarge` or larger)
- `kubectl` configured for your cluster
- NVIDIA device plugin installed on the cluster

## Deploy

```bash
kubectl apply -f deployment.yaml
```

## Verify

```bash
kubectl get pods -n ai-inference
kubectl logs -n ai-inference deployment/deepseek
```

## Test

```bash
kubectl port-forward -n ai-inference svc/deepseek 11434:11434
curl http://localhost:11434/api/generate \
  -d '{"model": "deepseek-r1:7b", "prompt": "Hello"}'
```

---

## Simpler alternative

Connect your EKS cluster to CaseDesk and deploy DeepSeek from the dashboard without writing manifests.

[https://getcasedesk.com](https://getcasedesk.com)
