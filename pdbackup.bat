<<<<<<< HEAD
 @echo off
   for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
     set dow=%%i
     set month=%%j
     set day=%%k
     set year=%%l
   )
   set datestr=%month%_%day%_%year%
   echo datestr is %datestr%
    
   set BACKUP_FILE=C:\backupservice\parisdhaba_production_%datestr%.backup
   echo backup file name is %BACKUP_FILE%
   SET PGPASSWORD=asd222
=======
 @echo off
   for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
     set dow=%%i
     set month=%%j
     set day=%%k
     set year=%%l
   )
   set datestr=%month%_%day%_%year%
   echo datestr is %datestr%
    
   set BACKUP_FILE=C:\backupservice\parisdhaba_production_%datestr%.backup
   echo backup file name is %BACKUP_FILE%
   SET PGPASSWORD=asd222
>>>>>>> 7b65526ebc566b406761db5db874edfff6dcd787
   pg_dump -i -h localhost -p 5432 -U gujmasala -F c -b -v -f %BACKUP_FILE% gujmasala_production