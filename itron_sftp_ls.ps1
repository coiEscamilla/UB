# Path variables
$Basepath 								= "."
$Sourcepath 							= "."

$SftpPath									= "sftp.itron-hosting.com:"
#$UploadPath								= "imports/csv"
$UploadPath								= "imports"
$DownloadPath							= "/"

$LogPath 									=	"$Sourcepath\itron_ls.log"

# username and password for payemntus agent dashboard
$FormFieldUser						= "FN5-IRVTX"
$SecureString =  gc .\FN5-IRVTX | ConvertTo-SecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)    

start-process "c:\Program Files (x86)\PuTTY\pscp.exe" -argumentlist "-l $FormFieldUser -pw $([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)) -ls $SftpPath/$UploadPath" -nonewwindow -wait;
