# For fio v2.0.x benchmark script with powershell v2.0
# Author: phillips.hsieh@falconstor.com
# Version: 1.0
param ([string]$target = "target", [string]$size = "size")
$model="FalconStor"
$time="30s"
$iomode1="read","randread","write","randwrite"
$iomode2="randrw"
$blocksize="512B","4k","8k","16k","32k","64k","128k","256k"
$iodepth=1,4,16,64


# Remove old csv file exist
if ( Test-Path .\"$model.Win64_fiov2.csv" )  { Remove-Item .\"$model.Win64_fiov2.csv" }


for ($i=0 ; $i -le ($iomode1.length -1); $i +=1)
{
	# Write-Host "iomode1:" $iomode1[$i]
	for ($j=0 ; $j -le ($blocksize.length -1); $j +=1)
	{
		for ($k=0 ; $k -le ($iodepth.length -1); $k +=1)
		{
			$iomode=$iomode1[$i]			
			$name="$iomode"+"_"+$blocksize[$j]+"_"+$iodepth[$k]+"D"
			.\fio --name=$name --rw=$iomode --direct=1 --ioengine=windowsaio --thread --runtime=$time --filename=$target --bs=$blocksize[$j] --iodepth=$iodepth[$k]  --size=$size --numjobs=1 --group_reporting --minimal | out-file -encoding ascii -append "$model.Win64_fiov2_temp.csv"
		}		
	}	
}	


#randrw read=70%, write=30% random=100%
# Write-Host "iomode1:" $iomode1[$i]
for ($j=0 ; $j -le ($blocksize.length -1); $j +=1)
{
	for ($k=0 ; $k -le ($iodepth.length -1); $k +=1)
	{
		$iomode=$iomode2
		$name="$iomode"+"_"+"r70w30"+"_"+$blocksize[$j]+"_"+$iodepth[$k]+"D"
		.\fio --name=$name --rw=$iomode --direct=1 --ioengine=windowsaio --rwmixread=70 --rwmixwrite=30 --thread --runtime=$time --filename=$target --bs=$blocksize[$j] --iodepth=$iodepth[$k]  --size=$size --numjobs=1 --group_reporting --minimal | out-file -encoding ascii -append "$model.Win64_fiov2_temp.csv"
	}
}	

#randrw read=30%, write=70% random=100%
# Write-Host "iomode1:" $iomode1[$i]
for ($j=0 ; $j -le ($blocksize.length -1); $j +=1)
{
	for ($k=0 ; $k -le ($iodepth.length -1); $k +=1)
	{
		$iomode=$iomode2
		$name="$iomode"+"_"+"r30w70"+"_"+$blocksize[$j]+"_"+$iodepth[$k]+"D"
		.\fio --name=$name --rw=$iomode --direct=1 --ioengine=windowsaio --rwmixread=30 --rwmixwrite=70 --thread --runtime=$time --filename=$target --bs=$blocksize[$j] --iodepth=$iodepth[$k]  --size=$size --numjobs=1 --group_reporting --minimal | out-file -encoding ascii -append "$model.Win64_fiov2_temp.csv"
	}
}	


# conver file to cvs format for Excel
$colStats = Get-Content "$model.Win64_fiov2_temp.csv"
foreach ($objBatter in $colStats)
{
	$objBatter -replace ";",","  | out-file -encoding ascii -append "$model.Win64_fiov2.csv"
	
}
Remove-Item .\"$model.Win64_fio2_temp.csv"

