## Insecure Docker Series
### Insecure Docker Registry II 

An unprotected private Docker registry is on the same network as your Kali machine. There is only one docker image present in the registry which contains the flag.
Objective: Fetch the image from the private Docker registry, analyze it and retrieve the flag!  No docker clients are provided and this exercise needs to be solved using first principles using curl.
Instructions : 
- This lab is dedicated to you! No other users are on this network :) 
- Once you start the lab, you will have access to a Kali terminal instance.
- Your Kali has an interface with IP address 192.X.Y.Z. Run "ip addr" to know the values of X and Y.
- The target server should be located at the IP address 192.X.Y.3. 
- Do not attack the gateway located at IP address 192.X.Y.1

Reference : https://attackdefense.com/challengedetails?cid=1025

### Misconfigured Docker Socket

To allow the developers interaction with Docker daemon, the system administrator has configured Docker daemon to listen on TCP socket on the localhost interface of the machine. In this lab exercise, you are provided a local low privileged user on the Docker server machine. 
Objective : 
- Leverage the Docker TCP socket to escalate privileges and retrieve the flag stored in the root directory of the host system!  
  
Reference : https://attackdefense.com/challengedetails?cid=1194
  
### Privilege Escalation I (AppArmor)  

The student user access is provided on a Docker host. The Docker daemon is using a TCP socket and only restricted functionality is exposed to non-root users.  
The AppArmor profiles are also deployed to confine the containers. The flag is kept in the home directory of the root user of the Docker host.  
  
**Objective** : Elevate access and retrieve the flag!  

