#!/bin/sh

# Set default values for Docker Swarm service arguments
DOCKER_COMPOSE_FILE="/drbd/cont_env/docker-compose.yml"
SERVICE_NAME="xcat_stack_xcat"
STACK_NAME="xcat_stack"

# Check if arguments are present in docker_swarm_service script
if grep -q 'DOCKER_COMPOSE_FILE=' ./resource-agents/heartbeat/docker_swarm_service \
    && grep -q 'SERVICE_NAME=' ./resource-agents/heartbeat/docker_swarm_service \
    && grep -q 'STACK_NAME=' ./resource-agents/heartbeat/docker_swarm_service; then

    # Move Docker Swarm service resource script to OCF directory
    mv ./resource-agents/heartbeat/docker_swarm_service /usr/lib/ocf/resource.d/heartbeat/
    chmod +x /usr/lib/ocf/resource.d/heartbeat/docker_swarm_service

    # Set default values in the resource script if not already set
    sed -i "s|: \${DOCKER_COMPOSE_FILE:=.*|: \${DOCKER_COMPOSE_FILE:=${DOCKER_COMPOSE_FILE}}|g" /usr/lib/ocf/resource.d/heartbeat/docker_swarm_service
    sed -i "s|: \${SERVICE_NAME:=.*|: \${SERVICE_NAME:=${SERVICE_NAME}}|g" /usr/lib/ocf/resource.d/heartbeat/docker_swarm_service
    sed -i "s|: \${STACK_NAME:=.*|: \${STACK_NAME:=${STACK_NAME}}|g" /usr/lib/ocf/resource.d/heartbeat/docker_swarm_service

    # Move systemd service unit file to systemd directory
    mv ./systemd/docker_swarm_service.service /usr/lib/systemd/system/
    chmod +x /usr/lib/systemd/system/docker_swarm_service.service

else
    echo "Required arguments not found in docker_swarm_service script."
    exit 1
fi
systemctl daemon-reload
systemctl enable docker_swarm_service.service
echo "Integration completed successfully."
#create resource of docker swarm service
pcs resource create docker_swarm_service ocf:heartbeat:docker_swarm_service service_name=xcat_stack_xcat stack_name=xcat_stack  op monitor interval=30s
rm  -rf ./resource-agents
rm  -rf ./systemd
