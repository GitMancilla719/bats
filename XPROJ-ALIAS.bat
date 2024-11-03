@echo off
setlocal

rem COPY THIS BAT FILE TO THE ROOT DIRECTORY OF YOUR PROJECT
rem THIS BAT FILE IS USED TO AUTOMATICALLY ADD AN ALIAS TO APACHE's httpd.conf FILE
rem AUTOMATICALLY MAKES THE LARAVEL APP RUN INSIDE XAMPP WITHOUT USING THE COMMAND php artisan serve
rem THE httpd.conf FILE WILL OPEN AFTER EXECUTING THE BAT FILE FOR DOUBLE CHECKING (DO NOT ALTER ANYTHING ASIDE FROM YOUR PROJECT RELATED CONCERNS)

rem Set the timezone to Manila (Philippines)
tzutil /s "Singapore Standard Time"

for /f "delims=" %%h in ('hostname') do set HOST_NAME=%%h

rem Get the current date and time and extract the first 8 digits (YYYYMMDD)
for /f "delims=.- " %%a in ('wmic os get localdatetime ^| find "."') do (
    set "CURRENT_DATE=%%a"
    goto :done
)
:done

rem Get the first 8 digits (YYYYMMDD)
set "CURRENT_YEAR=%CURRENT_DATE:~0,8%"

rem Get current folder name
for %%i in ("%cd%") do set "PROJECT_NAME=%%~ni"

findstr /C:"Alias /%PROJECT_NAME% \"C:/xampp/htdocs/%PROJECT_NAME%/public\"" "C:\xampp\apache\conf\httpd.conf" >nul

if %errorlevel% equ 0 (
    echo Status: ABORTED
    echo Message: Project already exists in the configuration file.
) else (
    echo Status: SUCCESS
    echo Message: Project was added in the configuration file.
    rem Append the configuration to httpd.conf
    (
        echo.
        echo ##### PROJECT: %PROJECT_NAME% - @%CURRENT_YEAR% y/m/d %HOST_NAME% ###########
        echo Alias /%PROJECT_NAME% "C:/xampp/htdocs/%PROJECT_NAME%/public"
        echo ^<Directory "C:/xampp/htdocs/%PROJECT_NAME%/public"^>
        echo     Options Indexes FollowSymLinks
        echo     AllowOverride All
        echo     Require all granted
        echo ^</Directory^>
        echo ##### PROJECT: %PROJECT_NAME% END 
        echo.
    ) >> "C:\xampp\apache\conf\httpd.conf"
)

rem Open httpd.conf in Notepad
rem notepad "C:\xampp\apache\conf\httpd.conf"

pause

endlocal