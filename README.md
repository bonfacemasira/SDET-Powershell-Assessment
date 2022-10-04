# SDET-Powershell-Assessment

Filter changed files
 10  
Brief Description.txt
@@ -0,0 +1,10 @@
Provide a brief description of how you would handle this scenario and then implement the solution in the automation script.



1. How to handle failed installation
Answer: Failed installation can be handled by implementing the try-catch block (which is already there)
2. How to log the events being handled by the automation script
Answer: Can output a log to a file which contains the exception message using $PSItem
3. How to ensure validity of data eg paths, .exe files throughout the execution of the script
Answer: use the Test-Path cmdlet
 33  
MainScript.ps1
