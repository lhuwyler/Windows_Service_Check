# Windows_Service_Check
Lists stopped windows services across your infrastructure
(because open the service mmc snap-in on all of your Servers really sucks)
     
# Windows-Service Check Script                                             

Lists all services in a given list of servers, whose startup tye is      
automatic but state is stopped.

Automatic Services which are down by default (why ever :D) can be        
excluded down below.                                                     
                                                                         
PARAMETER                                                                
- there are no parameters                                                
                                                                         
Servers to be checked can be defined in the $server array in the         
scripts config part (Hostname or FQDN)                                   
                                                                         
Exceptions for generally down services can be done in the $hidden array  
in the scripts config part. Make sure you type-in the original service   
name which can be found in the service property window, not the dis-     
play name.                                                               
                                                                         
                                                                        
                                                                         
