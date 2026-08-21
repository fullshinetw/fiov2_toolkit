# For fio v2.0.x benchmark script with powershell v2
# Author: phillips.hsieh@falconstor.com
# edition: fio_test.ps1 ver 1.0


$model="FalconStor"
$time="60s"
$iomode1="read","randread","write","randwrite"
$iomode2="randrw"
[string]$blocksize=$args[0] #blocksize input
[int]$iodepth=$args[1]
[int]$diskstart=$args[2]
[int]$diskend=$args[3]
[string]$csvfiledir=$args[4]
[string]$csvfilename=$args[5]
$size="100%"

Write-Host $args.count
if (($args.count -ne 4) -and ($args.count -ne 6))
{
	Write-Host "        "
	Write-Host "Example: .\fio_test <blocksize> <io_qdepth> <disknumber_start> <disknumber_end> [<log_path>] [<log_filename>]" 
	Write-Host "        "
	exit 0
}


# Write-Host $args[0] $args[1] $args[2] $args[3]
for ($i = $diskstart ; $i -le $diskend ; $i +=1)
{  
	if ( $i -eq $diskend )
	{
		$target+="\\.\Physicaldrive$i"
	}
	else 
	{
		$target+="\\.\Physicaldrive$i"+":"
	}
}

$choice=""
while ($choice -notmatch "[y|n]")
{
	Write-Host "        "
	Write-Host "This test will over-write I/O at disk $target"
	$choice = read-host "Do you want to continue? (y|n)"
}
if ($choice -eq "y")
{
	Write-Host "        "
	Write-Host "It will starting perform I/O benchmark at disk $target"
	Write-Host "        "
}
else
{
	Write-Host "Exit script"
	exit 0
}

# process logfile
	while (( $csvfiledir.length -eq 0 )  -or ($csvfilename.length -eq 0 ))
	{
		Write-Host "This test was not record I/O benchmark result in CSV file"
		$choice=""
		while ($choice -notmatch "[y|n]")
		{
			$choice = read-host "Do you want to type the logfile path? (y|n):"
		}
		if ($choice -eq "y")
		{
			while (($csvfiledir.length -eq 0 ) -and ($csvfilename.length -eq 0))
			{
				Write-Host "        "
				$csvfiledir = read-host "Please input the file location directory like as c:\ ->"
				$csvfilename = read-host "Please input the file name like as xxx.csv ->"
				Write-Host "        "
			}
			New-Item -path $csvfiledir -name $csvfilename -type "file" 
			
			if ( -not $? )
			{
				Write-Host " *** Please input correct PATH and FILENAME at next time execution *** "
				exit 1
			}
			else
			{
				break
			}
		}
		else
		{
			Write-Host "Perform the test without result logfile."
			$nolog=1
			break
		}
	}

	
for ($i=0 ; $i -le ($iomode1.length -1); $i +=1)
{
	$iomode=$iomode1[$i]			
	$name="$iomode"+"_"+$blocksize+"_"+$iodepth+"D"
	if ($nolog -eq 1)
	{
		.\fio --name=$name --rw=$iomode --direct=1 --ioengine=windowsaio --thread --runtime=$time --filename=$target --bs=$blocksize --iodepth=$iodepth  --size="$size" --numjobs=1 --group_reporting --minimal 
	}
	else
	{
		.\fio --name=$name --rw=$iomode --direct=1 --ioengine=windowsaio --thread --runtime=$time --filename=$target --bs=$blocksize --iodepth=$iodepth  --size="$size" --numjobs=1 --group_reporting --minimal | out-file -encoding ascii -append $csvfiledir$csvfilename
	}
}	


$iomode=$iomode2			
$name="$iomode"+"_"+"r70w30"+"_"+$blocksize+"_"+$iodepth+"D"
if ($nolog -eq 1)
{
	.\fio --name=$name --rw=$iomode --direct=1 --ioengine=windowsaio --rwmixread=70 --rwmixwrite=30 --thread --runtime=$time --filename=$target --bs=$blocksize --iodepth=$iodepth  --size=$size --numjobs=1 --group_reporting --minimal  
}
else
{
	.\fio --name=$name --rw=$iomode --direct=1 --ioengine=windowsaio --rwmixread=70 --rwmixwrite=30 --thread --runtime=$time --filename=$target --bs=$blocksize --iodepth=$iodepth  --size=$size --numjobs=1 --group_reporting --minimal  | out-file -encoding ascii -append $csvfiledir$csvfilename
}

$iomode=$iomode2		
$name="$iomode"+"_"+"r30w70"+"_"+$blocksize+"_"+$iodepth+"D"
if ($nolog -eq 1)
{
	.\fio --name=$name --rw=$iomode --direct=1 --ioengine=windowsaio --rwmixread=30 --rwmixwrite=70 --thread --runtime=$time --filename=$target --bs=$blocksize --iodepth=$iodepth --size=$size --numjobs=1 --group_reporting --minimal  
}
else
{
	.\fio --name=$name --rw=$iomode --direct=1 --ioengine=windowsaio --rwmixread=30 --rwmixwrite=70 --thread --runtime=$time --filename=$target --bs=$blocksize --iodepth=$iodepth --size=$size --numjobs=1 --group_reporting --minimal  | out-file -encoding ascii -append $csvfiledir$csvfilename
}



# conver file to cvs format for Excel
$colStats = Get-Content $csvfiledir$csvfilename
foreach ($objBatter in $colStats)
{
	$objBatter -replace ";",","  | out-file -encoding ascii -append $csvfiledir"report_"$csvfilename
	
}
Remove-Item $csvfiledir$csvfilename
Rename-Item -path $csvfiledir"report_"$csvfilename -newname $csvfiledir$csvfilename

