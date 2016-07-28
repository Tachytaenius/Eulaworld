@echo off
set /p file="Enter file name: "
copy %file% temp.txt
type header.txt > %file%
type temp.txt >> %file%
del temp.txt
echo Headering complete.