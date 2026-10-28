# Agent sandboxes

Experiments for running agents and agent harnesses inside sandboxes.

## Openshell

[OpenShell](https://docs.nvidia.com/openshell) by NVIDIA is designed to execute fleets of
autonomous agents.

Install using the provided [instructions](https://docs.nvidia.com/openshell/about/installation).

If you are using the Docker runtime and your docker socket is not on the standard path then create
`$HOME/.config/openshell/gateway.toml` with the following content:

```toml
[openshell]
version = 2

[openshell.gateway]
compute_driver = "docker"

[openshell.drivers.docker]
socket_path = "<your-docker-socket-path>"
```

and ensure the openshell service is running with

```bash
>openshell status
Server Status

  Gateway: openshell
  Server: https://localhost:17670
  Status: Connected
  Authentication: Authenticated (mTLS transport)
  Version: 0.1.5
```

### Openshell providers

#### Google Vertex AI

Import the relevant provider definition:

```bash
>openshell profile import --url https://raw.githubusercontent.com/NVIDIA/OpenShell/main/providers/google-cloud.yaml --global
```

Authenticate with Google Cloud using "Application Default Credentials" as you would normally.
