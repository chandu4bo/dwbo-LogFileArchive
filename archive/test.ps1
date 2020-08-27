$dirarray=New-Object System.Collections.ArrayList
$dirarray.Add("D:\Tomcat\tomcat")
$dirarray.Add("D:\Tomcat\tomcat\logs")

for($f=0; $f -lt $dirarray.Count; $f++)
{
  $ftypes="*.addons","*.hprof","*.log*","*.trc","*.txt","*.glf","*.zip"
  for($q=0; $q -lt $ftypes.Count; $q++)
  {
    $fileEntries = [IO.Directory]::GetFiles($dirarray[$f], $ftypes[$q]); 
    foreach($fileName in $fileEntries) 
    { 
      [Console]::WriteLine($fileName); 
    }
  }
}