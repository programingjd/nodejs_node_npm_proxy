@echo off

set CURL_PATH=
set UNZIP_PATH=
set GIT_PATH=

set WHERE_IS_CURL="where curl 2> NUL"
set WHERE_IS_UNZIP="where unzip 2> NUL"
set WHERE_IS_GIT="where git 2> NUL"

FOR /F "delims=" %%i IN ('%WHERE_IS_CURL%') DO set CURL_PATH=%%~si
FOR /F "delims=" %%i IN ('%WHERE_IS_UNZIP%') DO set UNZIP_PATH=%%~si
FOR /F "delims=" %%i IN ('%WHERE_IS_GIT%') DO set GIT_PATH=%%~si

IF "%CURL_PATH%"=="" GOTO no_curl_in_path
IF "%UNZIP_PATH%"=="" GOTO no_unzip_in_path
GOTO download

:no_curl
echo Could not find "curl" to download the go distribution archive.

GOTO EOF

GOTO EOF

:no_curl_in_path
IF "%GIT_PATH%"=="" GOTO no_curl ELSE (
  FOR %%i IN ("%GIT_PATH%") DO set GIT_PATH=%%~di%%~pi
  FOR %%i IN ("%GIT_PATH:~0,-1%") DO set GIT_PATH=%%~di%%~spi
  IF NOT EXIST "%GIT_PATH%usr\bin\curl.exe" GOTO no_curl 
  set CURL_PATH="%GIT_PATH%usr\bin\curl.exe"
)
GOTO download

:no_unzip_in_path
IF "%GIT_PATH%"=="" GOTO no_unzip ELSE (
  FOR %%i IN ("%GIT_PATH%") DO set GIT_PATH=%%~di%%~pi
  FOR %%i IN ("%GIT_PATH:~0,-1%") DO set GIT_PATH=%%~di%%~spi
  IF NOT EXIST "%GIT_PATH%usr\bin\unzip.exe" GOTO no_unzip 
  set UNZIP_PATH="%GIT_PATH%\usr\bin\unzip.exe"
)
GOTO download

:download
pushd %~dp0



set NODE4_DIR=node4
FOR %%i in ("%NODE4_DIR%") DO set NODE4_DIR=%%~fi
IF NOT EXIST "%NODE4_DIR%" (
  mkdir %NODE4_DIR%
  pushd %NODE4_DIR%
  echo Downloading latest Node 4.x ^(32bit^).
  "%CURL_PATH%" -k -O https://nodejs.org/dist/latest-v4.x/win-x86/node.exe
  rename node.exe node4.exe
  popd
)

set NODE5_DIR=node5
FOR %%i in ("%NODE5_DIR%") DO set NODE5_DIR=%%~fi
IF NOT EXIST "%NODE5_DIR%" (
  mkdir %NODE5_DIR%
  pushd %NODE5_DIR%
  echo Downloading Node 5.10.0 ^(64bit^).
  "%CURL_PATH%" -k -O https://nodejs.org/dist/v5.10.0/win-x64/node.exe
  rename node.exe node5.exe
  popd
)

set NPM_DISTRIBUTION_ARCHIVE=npm-1.4.12.zip
FOR %%i in ("%NPM_DISTRIBUTION_ARCHIVE%") DO set NPM_DISTRIBUTION_ARCHIVE=%%~fi
IF NOT EXIST "%NPM_DISTRIBUTION_ARCHIVE%" (
  echo Downloading npm 1.4.12.
  "%CURL_PATH%" -k -O https://nodejs.org/dist/npm/npm-1.4.12.zip
)

:extract
echo Extracting the npm distribution archive.
pushd %NODE4_DIR%
IF NOT EXIST "%NODE4_DIR%\npm4.cmd" (
  FOR /F "delims=" %%i in ('%UNZIP_PATH% -o -qq %NPM_DISTRIBUTION_ARCHIVE%') DO REM
  rename npm.cmd npm4.cmd
)
popd
pushd %NODE5_DIR%
IF NOT EXIST "%NODE5_DIR%\npm5.cmd" (
  FOR /F "delims=" %%i in ('%UNZIP_PATH% -o -qq %NPM_DISTRIBUTION_ARCHIVE%') DO REM
  rename npm.cmd npm5.cmd
)
popd

:compile
echo Compiling the node and npm proxies.
go install src\node.go
go install src\npm.go

:install
echo Updating the nodejs distributions.
xcopy /Y bin\node.exe node4
xcopy /Y bin\node.exe node5
xcopy /Y bin\npm.exe node4
xcopy /Y bin\npm.exe node5

popd

:eof
