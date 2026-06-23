# CaseDesk Examples

Practical examples for deploying open-source AI models to your own infrastructure.

## GPU VM Quickstarts

Provision a GPU VM, install Ollama, and run a model in minutes.

| Provider | Guide |
|---|---|
| AWS EC2 GPU | [aws-ec2-gpu](./gpu-vm-quickstarts/aws-ec2-gpu/) |
| Azure GPU VM | [azure-gpu-vm](./gpu-vm-quickstarts/azure-gpu-vm/) |
| GCP GPU VM | [gcp-gpu-vm](./gpu-vm-quickstarts/gcp-gpu-vm/) |
| Hetzner GPU VM | [hetzner-gpu-vm](./gpu-vm-quickstarts/hetzner-gpu-vm/) |

## Kubernetes Deployments

Deploy open-source models to your existing Kubernetes cluster.

| Example | Guide |
|---|---|
| DeepSeek on AWS EKS | [deploy-deepseek-aws-eks](./kubernetes/deploy-deepseek-aws-eks/) |
| Llama on Azure AKS | [deploy-llama-azure-aks](./kubernetes/deploy-llama-azure-aks/) |
| Qwen on GKE | [deploy-qwen-gke](./kubernetes/deploy-qwen-gke/) |

## OpenAI-Compatible API Examples

Use your self-hosted model with the OpenAI SDK.

| Language | Example |
|---|---|
| Python | [python/](./openai-compatible/python/) |
| JavaScript | [javascript/](./openai-compatible/javascript/) |

---

## Deploy with CaseDesk

Instead of managing manifests and SSH scripts manually, connect your cluster or VM once and deploy any model from the CaseDesk dashboard.

[https://getcasedesk.com](https://getcasedesk.com)
