@ECHO OFF

REM **********************************
REM * v0.1.0
REM **********************************

SETLOCAL ENABLEEXTENSIONS
set me=%~n0
set parent=%~dp0

REM Grab the first argument
set CMD=%1
shift

REM Push all arguments into a list 
:getnext
if -%1 == - goto endargs
	set ARGS=%ARGS% %1
	shift
	goto getnext
:endargs

REM **********************************
REM * HELP
REM **********************************
if "%CMD%" == "" goto Usage
if "%CMD%" == "--help" goto Usage
if "%CMD%" == "-H" goto Usage

REM **********************************
REM * BUILD
REM **********************************
if "%CMD%" == "--build_project" goto Build_Project
if "%CMD%" == "--build_host" goto Build_Host
if "%CMD%" == "--build_comm" goto Build_Comm
if "%CMD%" == "--build_loader" goto Build_Loader
if "%CMD%" == "--build_trp" goto Build_TRP
if "%CMD%" == "--build_vects" goto Build_VECTS
if "%CMD%" == "--build_integration" goto Build_Integration
if "%CMD%" == "--build_smbs" goto Build_SMBs
REM **********************************

REM **********************************
REM * CLEAN
REM **********************************
if "%CMD%" == "--clean_project" goto Clean_Project
if "%CMD%" == "--clean_host" goto Clean_Host
if "%CMD%" == "--clean_comm" goto Clean_Comm
if "%CMD%" == "--clean_loader" goto Clean_Loader
if "%CMD%" == "--clean_trp" goto Clean_TRP
if "%CMD%" == "--clean_vects" goto Clean_VECTS
if "%CMD%" == "--clean_integration" goto Clean_Integration
REM **********************************

echo Unsupported "build_batch %CMD%" command
goto Usage

:Build_Project
make --debug=b -f Makefile.wr all 2>&1 | gcc_error_parser.pl
goto end

:Build_Host
make --debug=b -f Makefile.wr Host_Build 2>&1 | gcc_error_parser.pl
goto end

:Build_Comm
make --debug=b -f Makefile.wr Comm_Build 2>&1 | gcc_error_parser.pl
goto end

:Build_Loader
make --debug=b -f Makefile.wr Loader_Build 2>&1 | gcc_error_parser.pl
goto end

:Build_TRP
make --debug=b -f Makefile.wr TRP_Build 2>&1 | gcc_error_parser.pl
goto end

:Build_VECTS
make --debug=b -f Makefile.wr VECTS_Build 2>&1 | gcc_error_parser.pl
goto end

:Build_Integration
make --debug=b -f Makefile.wr IntegrateProject 2>&1 | gcc_error_parser.pl
goto end

:Build_SMBs
make --debug=b -f Makefile.wr Build_SMBs 2>&1 | gcc_error_parser.pl
goto end

:Clean_Project
make --debug=b -f Makefile.wr clean 2>&1 | gcc_error_parser.pl
goto end

:Clean_Host
make --debug=b -f Makefile.wr clean_host 2>&1 | gcc_error_parser.pl
goto end

:Clean_Comm
make --debug=b -f Makefile.wr clean_comm 2>&1 | gcc_error_parser.pl
goto end

:Clean_Loader
make --debug=b -f Makefile.wr clean_loader 2>&1 | gcc_error_parser.pl
goto end

:Clean_TRP
make --debug=b -f Makefile.wr clean_trp 2>&1 | gcc_error_parser.pl
goto end

:Clean_VECTS
make --debug=b -f Makefile.wr clean_vects 2>&1 | gcc_error_parser.pl
goto end

:Clean_Integration
make --debug=b -f Makefile.wr clean_integration 2>&1 | gcc_error_parser.pl
goto end

:Usage

echo Usage: build_batch command 
echo where command is:
echo  --build_project		Build all CSCIs 
echo  --build_host		    Build Host CSCI	
echo  --build_comm			Build Comm CSCI	
echo  --build_loader		Build Loader CSCI	
echo  --build_trp			Build TRP CSCI	
echo  --build_vects			Build VECTS CSCI	
echo  --build_integration	Build project binaries 	
echo  --build_smbs			Build SMBs 
echo
echo  --clean_project		Clean all CSCIs 
echo  --clean_host		    Clean Host CSCI	
echo  --clean_comm			Clean Comm CSCI	
echo  --clean_loader		Clean Loader CSCI	
echo  --clean_trp			Clean TRP CSCI	
echo  --clean_vects			Clean VECTS CSCI	
echo  --clean_integration	Clean project binaries 	
echo  --clean_smbs			Clean SMBs 
exit /B 1

:end


