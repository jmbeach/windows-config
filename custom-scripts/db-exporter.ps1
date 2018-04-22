function db-export-schema() {
	$Filepath='D:\DatabaseBackups' # local directory to save build-scripts to
	$DataSource='localhost\SQLEXPRESS' # server name and instance
	$Database='SequenceEngine'# the database to copy from
	# set "Option Explicit" to catch subtle errors
	set-psdebug -strict
	$ErrorActionPreference = "stop" # you can opt to stagger on, bleeding, if an error occurs
	# Load SMO assembly, and if we're running SQL 2008 DLLs load the SMOExtended and SQLWMIManagement libraries
	$ms='Microsoft.SqlServer'
	$v = [System.Reflection.Assembly]::LoadWithPartialName( "$ms.SMO")
	$trash = [System.Reflection.Assembly]::LoadWithPartialName( "Microsoft.SqlServer.ConnectionInfo")
	if ((($v.FullName.Split(','))[1].Split('='))[1].Split('.')[0] -ne '9') {
		[System.Reflection.Assembly]::LoadWithPartialName("$ms.SMOExtended") | out-null
	}
	$My="$ms.Management.Smo" #
	$conn = new-object Microsoft.SqlServer.Management.Common.ServerConnection
	$conn.LoginSecure = $FALSE
	$conn.Login = "sa"
	$conn.Password = "Hyla10$"
	$conn.DatabaseName = "$Database"
	$conn.ServerInstance = "$DataSource"
	$s = new-object ("$My.Server") $conn
	if ($s.Version -eq  $null ){Throw "Can't find the instance $Datasource"}
	$db= $s.Databases[$Database] 
	if ($db.name -ne $Database){Throw "Can't find the database '$Database' in $Datasource"};
	$transfer = new-object ("$My.Transfer") $db
	$transfer.Options.ScriptBatchTerminator = $true # this only goes to the file
	$transfer.Options.ToFileOnly = $true # this only goes to the file
	$transfer.Options.Filename = "$($FilePath)\$($Database)_Schema.sql"; 
	try {
		$transfer.EnumScriptTransfer() 
	}
	catch [System.Exception] {
		$_.Exception
		if ($_.Exception.InnerException) {
			$_.Exception.InnerException
		}
	}
	"All done"
}

function db-export-data() {
	$Filepath='D:\DatabaseBackups' # local directory to save build-scripts to
	$DataSource='localhost\v12' # server name and instance
	$Database='SequenceEngine'# the database to copy from
	# set "Option Explicit" to catch subtle errors
	set-psdebug -strict
	$ErrorActionPreference = "stop" # you can opt to stagger on, bleeding, if an error occurs
	# Load SMO assembly, and if we're running SQL 2008 DLLs load the SMOExtended and SQLWMIManagement libraries
	$ms='Microsoft.SqlServer'
	$v = [System.Reflection.Assembly]::LoadWithPartialName( "$ms.SMO")
	$trash = [System.Reflection.Assembly]::LoadWithPartialName( "Microsoft.SqlServer.ConnectionInfo")
	if ((($v.FullName.Split(','))[1].Split('='))[1].Split('.')[0] -ne '9') {
		[System.Reflection.Assembly]::LoadWithPartialName("$ms.SMOExtended") | out-null
	}
	$My="$ms.Management.Smo" #
	$conn = new-object Microsoft.SqlServer.Management.Common.ServerConnection
	$conn.LoginSecure = $FALSE
	$conn.Login = "sa"
	$conn.Password = "Hyla10$"
	$conn.DatabaseName = "$Database"
	$conn.ServerInstance = "$DataSource"
	$s = new-object ("$My.Server") $conn
	if ($s.Version -eq  $null ){Throw "Can't find the instance $Datasource"}
	$db= $s.Databases[$Database] 
	if ($db.name -ne $Database){Throw "Can't find the database '$Database' in $Datasource"};
	$transfer = new-object ("$My.Transfer") $db
	$transfer.Options.ScriptBatchTerminator = $true # this only goes to the file
	$transfer.Options.ToFileOnly = $true # this only goes to the file
	$transfer.Options.Filename = "$($FilePath)\$($Database)_Data.sql"; 
	$transfer.Options.ScriptSchema = $false
	$transfer.Options.ScriptData = $true
	try {
		$transfer.EnumScriptTransfer() 
	}
	catch [System.Exception] {
		$_.Exception
		if ($_.Exception.InnerException) {
			$_.Exception.InnerException
		}
	}
	"All done"
}

function db-export-schema-cm() {
	$Filepath='D:\DatabaseBackups' # local directory to save build-scripts to
	$DataSource='localhost\v12' # server name and instance
	$Database='HylaHSConfig'# the database to copy from
	# set "Option Explicit" to catch subtle errors
	set-psdebug -strict
	$ErrorActionPreference = "stop" # you can opt to stagger on, bleeding, if an error occurs
	# Load SMO assembly, and if we're running SQL 2008 DLLs load the SMOExtended and SQLWMIManagement libraries
	$ms='Microsoft.SqlServer'
	$v = [System.Reflection.Assembly]::LoadWithPartialName( "$ms.SMO")
	$trash = [System.Reflection.Assembly]::LoadWithPartialName( "Microsoft.SqlServer.ConnectionInfo")
	if ((($v.FullName.Split(','))[1].Split('='))[1].Split('.')[0] -ne '9') {
		[System.Reflection.Assembly]::LoadWithPartialName("$ms.SMOExtended") | out-null
	}
	$My="$ms.Management.Smo" #
	$conn = new-object Microsoft.SqlServer.Management.Common.ServerConnection
	$conn.LoginSecure = $FALSE
	$conn.Login = "sa"
	$conn.Password = "Hyla10$"
	$conn.DatabaseName = "$Database"
	$conn.ServerInstance = "$DataSource"
	$s = new-object ("$My.Server") $conn
	if ($s.Version -eq  $null ){Throw "Can't find the instance $Datasource"}
	$db= $s.Databases[$Database] 
	if ($db.name -ne $Database){Throw "Can't find the database '$Database' in $Datasource"};
	$transfer = new-object ("$My.Transfer") $db
	$transfer.Options.ScriptBatchTerminator = $true # this only goes to the file
	$transfer.Options.ToFileOnly = $true # this only goes to the file
	$transfer.Options.Filename = "$($FilePath)\$($Database)_Schema.sql"; 
	try {
		$transfer.EnumScriptTransfer() 
	}
	catch [System.Exception] {
		$_.Exception
		if ($_.Exception.InnerException) {
			$_.Exception.InnerException
		}
	}
	"All done"
}

function db-export-data-cm() {
	$Filepath='D:\DatabaseBackups' # local directory to save build-scripts to
	$DataSource='localhost\v12' # server name and instance
	$Database='HylaHSConfig'# the database to copy from
	# set "Option Explicit" to catch subtle errors
	set-psdebug -strict
	$ErrorActionPreference = "stop" # you can opt to stagger on, bleeding, if an error occurs
	# Load SMO assembly, and if we're running SQL 2008 DLLs load the SMOExtended and SQLWMIManagement libraries
	$ms='Microsoft.SqlServer'
	$v = [System.Reflection.Assembly]::LoadWithPartialName( "$ms.SMO")
	$trash = [System.Reflection.Assembly]::LoadWithPartialName( "Microsoft.SqlServer.ConnectionInfo")
	if ((($v.FullName.Split(','))[1].Split('='))[1].Split('.')[0] -ne '9') {
		[System.Reflection.Assembly]::LoadWithPartialName("$ms.SMOExtended") | out-null
	}
	$My="$ms.Management.Smo" #
	$conn = new-object Microsoft.SqlServer.Management.Common.ServerConnection
	$conn.LoginSecure = $FALSE
	$conn.Login = "sa"
	$conn.Password = "Hyla10$"
	$conn.DatabaseName = "$Database"
	$conn.ServerInstance = "$DataSource"
	$s = new-object ("$My.Server") $conn
	if ($s.Version -eq  $null ){Throw "Can't find the instance $Datasource"}
	$db= $s.Databases[$Database] 
	if ($db.name -ne $Database){Throw "Can't find the database '$Database' in $Datasource"};
	$transfer = new-object ("$My.Transfer") $db
	$transfer.Options.ScriptBatchTerminator = $true # this only goes to the file
	$transfer.Options.ToFileOnly = $true # this only goes to the file
	$transfer.Options.Filename = "$($FilePath)\$($Database)_Data.sql"; 
	$transfer.Options.ScriptSchema = $false
	$transfer.Options.ScriptData = $true
	try {
		$transfer.EnumScriptTransfer() 
	}
	catch [System.Exception] {
		$_.Exception
		if ($_.Exception.InnerException) {
			$_.Exception.InnerException
		}
	}
	"All done"
}
