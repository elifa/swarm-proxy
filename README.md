# Privileged Docker service proxy
This proxy allows you to run Docker containers as `--privileged` or with `--cap-add` in a Docker Swarm.

## Usage
Running a Docker container with additional privileges usually looks something like this:

`docker run --cap-add=IPC_LOCK -d --name=my-vault -p 80:8200 vault`

Using the service proxy this service would be deployable as a service using the following command:

`docker service create --name=my-vault --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock --env RUN="--cap-add=IPC_LOCK -p 8200:8200 vault" elifa/swarm-proxy 80:8200`

Where the last argument is the proxy mapping from the service to the underlying container.

## Consequences
Running a container with additional capabilities has it's own risks, additionally this approach unfortunately requires the ports of the dynamically created local container to be exposed on the hosts. Be aware of the risks this involves before using this approach.

## Limitation
No support for health checks (unless you extend this image for a specific service), only support for one port exposed from the container.