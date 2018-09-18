# Path variables
$Sourcepath 							= "."
$FileName									= "test.txt"

$SftpPath									= "sftp.itron-hosting.com:"
$UploadPath								= "imports"
$DownloadPath							= "/"

$LogPath 									=	"$Sourcepath\itron.log"

# username and password for sftp
$FormFieldUser						= "FN5-IRVTX"
$SecureString =  gc .\FN5-IRVTX | ConvertTo-SecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)

# Start logs and create direct ory 
Start-Transcript -Path $LogPath -Append

trap { 
	$_ | out-file "$Sourcepath\debug_output.txt"; 
	Continue;
}

start-process "c:\Program Files (x86)\PuTTY\pscp.exe" -argumentlist "-l $FormFieldUser -pw $([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)) $Sourcepath\$FileName $SftpPath/$UploadPath" -nonewwindow -wait;

#Uncomment for List Directory
#start-process "c:\Program Files (x86)\PuTTY\pscp.exe" -argumentlist "-l $FormFieldUser -pw $([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)) -ls $SftpPath" -nonewwindow -wait;

Stop-Transcript

return 0;

