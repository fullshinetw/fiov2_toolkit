# FIO ver2 – Flexible IO Tester script

- Introduction

- Package Required

- Script parameter and output and running environment

- Limitation	

- Additional Reference	



# Introduction

This document descript how to use the script under Windows x86/Windows x64 and Linux platform for perform the RAW device I/O performance as we usually using IO benchmark tool called “IOMeter”.

# Package Required

You will need install the fio with RPM package or compiler that with source code. That will need packages from Linux installation media, there are list as below.


For RHEL5UX and CentOS5.X:

*libaio-0.3.x  (fio binary depends library)*

*libaio-devel-0.3.x (if you want to compiler with fio source code)*


For Windows platform: 

You need to follow below suggest package for different x86 or x64 Windows OS.

*fio-2.0.1+\_20120201.msi* (for WindowsXP/2003/7 x86)

*fio-2.0.7-x64.msi* (for Windows2008R2 x64)

# Script parameter and output and running environment

The script “falcon\_io\_fio\_v2\_for\_excel.sh” support CentOS/RHEL/OEL Linux operating system

The script “falcon\_io\_fio\_v2\_for\_excel\_win.sh” support Windows2003/XP/Vista x86 operation system

The script “falcon\_io\_fio\_v2\_for\_excel\_winx64.ps1” support Windows2008R2 x64 operation system with Power Shell v2.

The script “fio\_test.ps1” was using fio v2.x on Windows Power Shell environment to throughput I/O with parameters **block-size**, **qdepth**, **starting disk number** and **ending disk number**. Which define the access size default use 100%. Otherwise, we have adding another two parameters **result log file path** and **file name**.

The script “fio\_test.sh” was using fio v2.x on Unix Bash Shell environment to throughput I/O with parameters **block-size**, **qdepth**, **target\_disks**. Which define the access size default use 100%. Otherwise, we have adding another one parameter for add **result log file with path**.


**Parameter input Example**:

.\\falcon\_io\_fio\_v2\_for\_excel.sh –target /dev/sdb:/dev/sdc –size \[Disk Size % | block numbers(GB|MB)\]*  \# for Linux*

./falcon\_io\_fio\_v2\_for\_excel\_win.sh –target \\\\.\\PhysicalDrive1:\\\\.\\PhysicalDrive2 -size \[Disk Size % | block numbers\]

.\\falcon\_io\_fio\_v2\_for\_excel\_winx64.ps1 –target \\\\.\\PhysicalDrive1:\\\\.\\PhysicalDrive2 -size \[Disk Size % | block numbers(GB|MB)\]

./falcon\_io\_fio\_v2\_for\_excel\_winx64.ps1 e\:\\fio\fio.dat 10G

.\\fio\_test.ps1 16k 4 1 20 c:\\  io\_result\_log.csv* \# t  block size=16k, qdepth=4, target disk start from \\\\.\\PhysicalDrive1,  target disk end to  \\\\.\\PhysicalDrive20, save the log in c:\\ and the result log file naming is “io\_result\_log.csv”. *

*./fio\_test.sh 16k 4 /dev/sdb;/dev/sdc  /root/io\_result\_log.csv *



**Windows environment requirement:**

For all Windows environment, please copy which supported FalconStor fio script into “C:\\Program Files\\fio\\bin”(Win32s)  or “C:\\Profile Files\\fio” directory. 

For Win32s, please change directory to “C:\\Program File\\fio” then right click “fio.bat” and select “run as Administrator” under Win7/Vista. 

For Windows2008R2 x64, please launch the Power Shell environment first and then change directory to “C:\\Program Files\\fio” to run with supported script. 

If you see below fail execution message:

File C:\\Program Files\\fio\\falcon\_io\_fio\_v2\_for\_execel\_winx64.ps1 cannot be loaded because the execution of scripts is disabled on this system. Please see “get-help about\_signing” for more details.

At line:1 char:40

+ .\\falcon\_io\_fio\_v2\_for\_execel\_winx64.ps1 \<\<\<\< -target [\\\\.\\PhysicalDrive2](file://./PhysicalDrive2) -size 100%

    + Categoryinfo	:NotSpecified: (:)\[\], PSSEcurityExeception 

    + FullyQualifiedErrorId: RuntimeException


To run unsigned scripts that you write on your local computer and signed scripts from other users, use the following command to change the execution policy on the computer to RemoteSigned.

PS\> *set-executionpolicy remotesigned*


**Adjust Script Options**:

If the benchmark target device were multiple raw devices. You can specify a number of files and physical disks by separating the names with a ‘**:**’ character.

All of test pattern duration default set 30sec. You could change that by modify script and change port “$time=Ns “.


**CVS ready for import:**

After you run the command as example that will output a CSV format file like below. 

FalconStor.Linux.fiov2.csv

FalconStor.Windowsx86.fiov2.csv

FalconStor.Win64.fiov2.csv

Which file will be read with Excel file called “FS Benchmark Standard-1 READ WRITE Record-1.05\_fiov2.xls”. After the Excel file have imported the CSV file that will automatic draw I/O performance chat and easy read the benchmark data. 

If the benchmark result report created by “fio\_test.ps1” and “fio\_test.sh” both can be imported the reporting file with Excel file called “fiov2\_log\_reader.xls”. Then you can follow the mapping of column to know the result value.

# Limitation

So far, we were prepared the fio script that hard functions I/O access pattern included below list.

100% sequential read

100% sequential write 

100% random read

100% random write

Mix 70% random read and 30% random write

Mix 30% random read and 70% random write


If the testing only need a single type I/O benchmark, you can use the “fio\_test.ps1” for Windows or “fio\_test.sh” for Linux and customize it as expected. 


**Important**:

If your testing platform is Windows7/Vista/Windows2008R2/Windows2022 that maybe encounter no Administration permission to access raw disk I/O. Please execute the script with as Administrator. 

# Additional Reference

fio – flexible I/O tester 

	[http://freecode.com/projects/fio](http://freecode.com/projects/fio) fio project source code

	[http://pkgs.repoforge.org/fio/](http://pkgs.repoforge.org/fio/)  on-line RPM library support RHEL 4/5/6 and CentOS 4/5/6

	[http://www.bluestop.org/fio/](http://www.bluestop.org/fio/) fio for Windows platform

PS: fio support multi-platform, for Linux which required pre-install libaio rpm. If your system was not installed it, you can found that package of installation DVD or ISO file.
