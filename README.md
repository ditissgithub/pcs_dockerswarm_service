# pcs_dockerswarm_service
# Integrate Docker Swarm xCAT Service with DRBD_PCS:

To integrate the Docker Swarm xCAT service with PCS,:

Source the Docker Swarm service heartbeat resource (`docker_swarm_service`) and the systemd unit file (`docker_swarm_service.service`) from GitHub or a local repository onto both HA nodes (master01 and master02) equipped with DRBD.

source: https://github.com/ditissgithub/pcs_dockerswarm_service.git

#####On Both DRBD Master HA node############

$cd /root/xcat_env

#If /root/xcat_env not present then create on both drbd HA master node.

#Pull from github

$git clone https://github.com/ditissgithub/pcs_dockerswarm_service.git

$ cd pcs_dockerswarm_service

$bash config.sh

#Verify whether the `docker_swarm_service` resource agent has been successfully integrated with OCF (Open Cluster Framework).

$pcs resource list ocf  | grep docker

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/85d770dd-d982-4f3f-97c8-f8272e096fae/1d2c7d8c-4c86-4f7c-9774-f48ea0007096/Untitled.png)

#######Only On Primary Master Node (In my case master01)

#Resource and Constraint Creation
Configure and apply resource creation and constraints for Docker Swarm service using the `docker_swarm_service` resource script with PCS (Pacemaker/Corosync).

$pcs resource create docker_swarm_service ocf:heartbeat:docker_swarm_service service_name=xcat_stack_xcat stack_name=xcat_stack  op monitor interval=30s

$pcs constraint colocation add docker_swarm_service with xcatfs INFINITY
$pcs constraint order start xcatfs then start docker_swarm_service

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/85d770dd-d982-4f3f-97c8-f8272e096fae/ca219213-541b-4fdd-a063-efbf181ac607/Untitled.png)

$pcs resource refresh

$pcs status

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/85d770dd-d982-4f3f-97c8-f8272e096fae/fec26610-42b6-4c37-abe9-6d44a3ee3956/Untitled.png)

$pcs constraint location vip_xCAT prefers master02=50

$pcs constraint location vip_xCAT prefers master01=100

$pcs constraint order set vip_xCAT drbd_fs_clone xcatfs docker_swarm_service
