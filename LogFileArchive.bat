d:
cd "\dwbo\LogFileArchive"

c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -File LogFileArchive.ps1 "Apache">"LogFileArchive_Apache_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"

rem c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -File LogFileArchive.ps1 "BOE">"LogFileArchive_BOE_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"

c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -File LogFileArchive.ps1 "Tomcat">"LogFileArchive_Tomcat_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"