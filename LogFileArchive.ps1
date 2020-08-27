Import-Module .\powershellzip\PowerShellZip.dll

$dirarray=New-Object System.Collections.ArrayList

if ($Args[0] -eq "Apache") {

$dirarray.Add("D:\Program Files (x86)\Apache Software Foundation\Apache24\logs")
Write-Host "Apache folders set" $OFS

}


if ($Args[0] -eq "BOE") {

$dirarray.Add("D:\Program Files (x86)\SAP BusinessObjects")
$dirarray.Add("D:\Program Files (x86)\SAP BusinessObjects\SAP BusinessObjects Enterprise XI 4.0\logging")
Write-Host "BOE folders set" $OFS

}

if ($Args[0] -eq "Tomcat") {

$dirarray.Add("D:\Tomcat\tomcat")
$dirarray.Add("D:\Tomcat\tomcat\logs")
Write-Host "Tomcat folders set" $OFS

}


$dirarray.Add("D:\dwbo\LogFileArchive")

$Tflocked = 0
$Tfskipped = 0
$Tfdeleted = 0
$locked = 0
$OFS = "`r`n"
$a = Get-Date
$zipname=$a.ToShortDateString().Replace("/","-") + ".zip"
$ftypes="*.addons","*.hprof","*.log*","*.trc","*.txt","*.glf","*.zip"
#Write-Host "ftypes length: " $ftypes.Length $OFS
#Write-Host "ftypes count: " $ftypes.Count $OFS
#Write-Host "Press any key to continue ..." $OFS
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

for($f=0; $f -lt $dirarray.Count; $f++)
{

  $flocked = 0
  $fskipped = 0
  $fdeleted = 0

  Write-Host "CD -- " $dirarray[$f] $OFS
  cd $dirarray[$f]
  
  $filearray=New-Object System.Collections.ArrayList
  $array=New-Object System.Collections.ArrayList

  for($q=0; $q -lt $ftypes.Count; $q++)
  {
    #$array = dir -r $ftypes[$q] | % { if ($_.PsIsContainer) { $_.FullName + "\" } else { $_.FullName } }
	$array=[IO.Directory]::GetFiles($dirarray[$f], $ftypes[$q])
	if ($array)
	{
	  #Write-Host "array type: " $array.GetType() $OFS;
      #Write-Host "Press any key to continue ..." $OFS
      #$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	  if ($array.GetType().ToString().equals("System.String"))
	  {
	    $filearray.Add($array)
	  }
	  else
      {	  
	    for($i=0; $i -lt $array.Count;$i++) 
        {
          #Write-Host $array[$i] $OFS
	      $filearray.Add($array[$i])
		}
      }
	}
  }
  #Write-Host "filearray: " $filearray $OFS
  #Write-Host "Press any key to continue ..." $OFS
  #$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

  for($i=0; $i -lt $filearray.Count;$i++) 
  {

    $locked = 0

    #Write-Host "filearray[i]: " $filearray[$i] $OFS
    #Write-Host "Press any key to continue ..." $OFS
    #$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	
    $file=gci $filearray[$i]
    #Write-Host $file $OFS
    #Write-Host $file.LastWriteTime $OFS
	$extension=[System.IO.Path]::GetExtension($file)
	$daysago=-7
	$onlydelete="no"
	if ($extension.ToLower().equals(".zip"))
	{
	  $daysago=-30
	  $onlydelete="yes"
	}
    if ($file.LastWriteTime -lt $a.AddDays($daysago))
    {
      Write-Host $file "last modify:" $file.LastWriteTime.ToShortDateString() " - zip/delete!!" $OFS

		try {
   			[IO.File]::OpenWrite($file).close();
			$locked = 0

		}catch {
			Write-Host $file "File in use " $OFS
			$locked = 1
		  	$flocked++
		}


	  if ($onlydelete.equals("no"))
	  {

		  if ($locked -eq 0){
	    		Export-Zip $zipname $file -EntryRoot $dirarray[$f] -append
		}

      }

	  if ($locked -eq 0){
		  Remove-Item $file
		  $fdeleted++
	 }

    }
    else
    {
      Write-Host $file "last modify:" $file.LastWriteTime.ToShortDateString() ">" $a.AddDays($daysago).ToShortDateString() " - skip less than 7 days old" $OFS
      $fskipped++
    }
  }

$Tfskipped = $Tfskipped + $fskipped
$Tfdeleted = $Tfdeleted + $fdeleted
$Tflocked = $Tflocked + $flocked
		  	
Write-Host "Deleted File count: " $fdeleted $OFS
Write-Host "Skipped File count: " $fskipped $OFS
Write-Host "Locked File count: " $flocked $OFS


}

Write-Host $OFS$OFS$OFS


Write-Host "Total Deleted File count: " $Tfdeleted $OFS
Write-Host "Total Skipped File count: " $Tfskipped $OFS
Write-Host "Total Locked File count: " $Tflocked $OFS


#$a = Get-Date
#"Date: " + $a.ToShortDateString()
#$b=$a.AddDays(-90)
#"Date: 90 days ago: " + $b.ToShortDateString()
#Write-Host $zipname $OFS
