#!/bin/sh

#Copy the Docker Swarm service resource script to the OCF directory for use as a PCS resource.

mv ./resource-agents/heartbeat/docker_swarm_service /usr/lib/ocf/resource.d/heartbeat/
chmod +x /usr/lib/ocf/resource.d/heartbeat/docker_swarm_service
mv ./systemd/docker_swarm_service.service /usr/lib/systemd/system/
chmod +x /usr/lib/systemd/system/docker_swarm_service.service
