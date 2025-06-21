@echo off
setlocal EnableDelayedExpansion


:: intro text
title Upload Process
echo =========================
echo Please wait... Let me do my magic
echo =========================


:: root folder in which the script gets called
set "root=%~dp0"


:: last folder that got added to the root
set "new_folder="
for /f "delims=" %%d in ('dir /ad /b /o-d "%root%"') do (
    set "new_folder=%%d"
	goto :gotfolder
)
:gotfolder


:: go through the list of all untracked git files
set "allValid=true"
set "git_files="
set "git_files_length="
for /f "delims=" %%f in ('git ls-files --others --exclude-standard') do (
    
	:: save file in git_files lists
	set "file=%%f"
    set "git_files=!git_files! !file!"
	set /a git_files_length+=1

    :: extract folder name the file is located in (before first "/")
    for /f "delims=/ tokens=1" %%p in ("!file!") do (
		
		:: untracked git file is not located inside newest folder
		if /i not "%%p"=="!new_folder!" (
			echo Please ensure that exactly one folder got added!
			pause
			exit /b
		)
    )
)


:: debug output
echo Folder that was added: !new_folder!
echo Containing the following untracked git files: !git_files!
echo =========================


:: search for image.jpg
echo Searching for image.jpg ...
set "search1=image.jpg"
echo !git_files! | findstr /i "%search1%" >nul
if not errorlevel 1 (
    echo Found image.jpg
	echo =========================
) else (
    echo No match found. Please add a file "image.jpg" to showcase your game!
	pause
	exit /b
)


:: search for README.md
echo Searching for README.md ...
set "search2=README.md"
echo !git_files! | findstr /i "%search2%" >nul
if not errorlevel 1 (
    echo Found README.md
	echo =========================
) else (
    echo No match found. Please add a file "README.md" to showcase your game!
	pause
	exit /b
)


:: search for game.exe
echo Searching for game.exe ...
set "search3=game.exe"
echo !git_files! | findstr /i "%search3%" >nul
if not errorlevel 1 (
    echo Found game.exe
	echo =========================
) else (
    echo No match found. Please add a file "game.exe" to showcase your game!
	pause
	exit /b
)


:: check if there are any other unwanted files
:: echo Searching for any invalid files ...
:: echo git_files_length = !git_files_length!
:: if !git_files_length! GTR 3 (
::     echo Found unwanted files.
::     pause
::     exit /b 1
:: )
:: echo No invalid files were found
:: echo =========================


:: ready for upload
echo Starting the upload process!
echo =========================


:: adding LFS
echo Installing Git LFS (Large File Storage) ...
git lfs install
echo =========================
echo Tracking ".exe" files ...
git lfs track "*.exe"
echo =========================
echo Adding .gitattributes ...
git add .gitattributes
echo =========================
echo Commiting .gitattributes ...
git commit -m "Track .exe files with Git LFS"
echo =========================


:: adding new game
echo Adding your folder ...
git add !git_files!
echo =========================
echo Commiting your folder ...
git commit -m "Add new game"
echo =========================
echo Pushing your folder to origin ...
git push origin main
echo =========================
echo Process finished.. You can close this window now.
echo =========================
pause
exit /b 0