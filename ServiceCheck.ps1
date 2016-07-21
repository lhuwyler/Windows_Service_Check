#==========================================================================#
# Windows-Service Check Script                                             #
#==========================================================================#
#                                                                          #
# Lists all services in a given list of servers, whose startup tye is      #
# automatic but state is stopped.                                          #
#                                                                          #
# Automatic Services which are down by default (why ever :D) can be        #
# excluded down below.                                                     #
#                                                                          #
# PARAMETER                                                                #
# - there are no parameters                                                #
#                                                                          #
# Servers to be checked can be defined in the $server array in the         #
# scripts config part (Hostname or FQDN)                                   #
#                                                                          #
# Exceptions for generally down services can be done in the $hidden array  #
# in the scripts config part. Make sure you type-in the original service   #
# name which can be found in the service property window, not the dis-     #
# play name.                                                               #
#                                                                          #
#                                                                          #
# Changelog:                                                               #
# 2015-10-12 Huwylerl: Finished                                            #
#                                                                          #
#==========================================================================#

# Script config (edit below)

$servers = @(
    "server1"
    "server2"
    "server3.fqdn.local"
)

$hidden = @(
    "clr_optimization_v4.0.30319_64" #.NET Framework
    "clr_optimization_v4.0.30319_32" #.NET Framework
    "ShellHWDetection" # Shell Hardwareerkennung
    "sppsvc" # Software Protection
    "RemoteRegistry" # Remoteregistrierung
)

#==========================================================================#
# Functions                                                                #
#==========================================================================#


function getServiceDisplayName($WmiServiceObject){
    Try 
    {
        $service = get-service -Name $WmiServiceObject.Name -ComputerName $WmiServiceObject.__SERVER -ErrorAction Stop
        return $service.DisplayName
    }
    Catch
    {
        $errortext = ('Display-Name not found, but Service name is "' + $WmiServiceObject.Name + '"')
        return $errortext
    }
}

#==========================================================================#
# Main                                                                     #
#==========================================================================#

foreach ($server in $servers){
    write-host "----------------------------------------"
    Try
    {
        # Get a list of all Services from the current server
        $services = Get-WmiObject -computername $server win32_service -ErrorAction Stop

        # Select services, whose state is stopped and startup-type is auto
        $services = $services | Where-Object {$_.State -like "Stopped"}
        $services = $services | Where-Object {$_.StartMode -like "Auto"}
        $services = $services | Where-Object {$hidden -notcontains $_.Name}
        
        # check if there are any matching services from the query above
        if ($services){
            write-host $server.ToUpper()
            write-host
            # print-out matching services' display name
            foreach ($service in $services){
                    $serviceDisplayName = getServiceDisplayName $service
                    write-host (" --> " + $serviceDisplayName)
            }
        } else {
            write-host -ForegroundColor green ($server.ToUpper() + " seems to be ok")
        }

    }
    Catch
    {
        write-host -ForegroundColor red ("could not contact " + $server.ToUpper())
    }
}
write-host
write-host -ForegroundColor yellow "Mit freundlichen Grüssen von Lukas :D"
write-host
pause
