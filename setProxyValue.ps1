####################################################################################
#- Usage:          PowerShell.exe -ExecutionPolicy Bypass -File setProxyValue.ps1 -setProxy True #: if you want to start proxy
#-                 PowerShell.exe -ExecutionPolicy Bypass -File setProxyValue.ps1 -setProxy False #: if you want to stop proxy
#-----------------------------------------------------------------------------------
#- Title:          Script turn on and turn off proxy
#-----------------------------------------------------------------------------------
#- Description:    Script turn on and turn off proxy
#- Documentation:  
#-----------------------------------------------------------------------------------
## Author:         lszabo
## Release date:   21.10.2019
#- Version:        1.0
#-----------------------------------------------------------------------------------
#- Notes/innspired by:		  https://stackoverflow.com/questions/29623788/how-to-apply-changed-proxy-settings-autoconfigurl-with-powershell
#				  			  https://erwinbierens.com/powershell-enabledisable-windows-web-proxy/
#				  			  https://winaero.com/blog/create-shortcut-ps1-powershell-file-windows-10/
#-----------------------------------------------------------------------------------
## History:
####################################################################################

param(
[string]$setProxy
)

function refresh-system(){
    $signature = @'
[DllImport("wininet.dll", SetLastError = true, CharSet=CharSet.Auto)]
public static extern bool InternetSetOption(IntPtr hInternet, int dwOption, IntPtr lpBuffer, int dwBufferLength);
'@

    $INTERNET_OPTION_SETTINGS_CHANGED   = 39
    $INTERNET_OPTION_REFRESH            = 37
    $type = Add-Type -MemberDefinition $signature -Name wininet -Namespace pinvoke -PassThru
    $a = $type::InternetSetOption(0, $INTERNET_OPTION_SETTINGS_CHANGED, 0, 0)
    $b = $type::InternetSetOption(0, $INTERNET_OPTION_REFRESH, 0, 0)
    #return $a -and $b
}

if ($setProxy -eq "True"){
	set-itemproperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -value 1;
    refresh-system;
}

if ($setProxy -eq "False"){
	set-itemproperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -value 0;
    refresh-system;
}
