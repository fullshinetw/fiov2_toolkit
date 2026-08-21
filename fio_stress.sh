# For fio v2.0.x benchmark script with linux bash shell
# Author: phillips.hsieh@falconstor.com
# edition: fio_test.sh ver 1.0


model="FalconStor"
time="60s"
iomode1="read randread write randwrite"
iomode2="randrw"
blocksize=$1 #blocksize input
iodepth=$2
disktargets=$3
csvfilename=$4
size="500MB"

input=$#
if [ $input -eq 0 ]
then
	echo "Example: ./fio_test <blocksize> <io_qdepth> <targets> [<log_filename>]" 
	exit 0
fi	

if [ $input -ne 3 ] && [ $input -ne 4 ]
then
	echo "        "
	echo "Example: ./fio_test <blocksize> <io_qdepth> <targets> [<log_filename>]" 
	echo "        "
	exit 0
else
	echo "        "
	echo "This test will over-write I/O at disk $disktargets"
	echo "Do you want to continue? (y|n)"
	read -t 30  answer
fi

if [ $answer = "y" ]
then
	echo "        "
	echo "It will starting perform I/O benchmark at disk $disktargets"
	echo "        "
else
	echo "Exit script....."
	exit 0
fi

# process logfile
if [ -z $csvfilename ]
then
	echo "This test was not record I/O benchmark result in CSV file"
	echo "Do you want to type the logfile path? (y|n):"
	read -t 30 answer1
	if [ $answer1 = "y" ]
	then
		echo "        "
		"Please input the file location path and name like as /root/a.log ->"
		read csvfilename
		touch $csvfilename
		if [ $? -eq 1 ]
		then
			echo " *** Please input correct PATH and FILENAME at next time execution *** "
			exit 1
		else
			rm -f $csvfilename
		fi
	else
		echo "Perform the test without result logfile."
		nolog=1
	fi
else
	nolog=0
fi	

#for iomode in `echo $iomode1`
#do
	
#	name="${iomode}_${blocksize}_${iodepth}D"
#	if [ $nolog -eq 1 ]
#	then
#		fio --name=$name --rw=$iomode --direct=1 --thread --runtime=$time --filename=$disktargets --bs=$blocksize --iodepth=$iodepth  --size="$size" --numjobs=1 --group_reporting --minimal 
#	else
#		fio --name=$name --rw=$iomode --direct=1 --thread --runtime=$time --filename=$disktargets --bs=$blocksize --iodepth=$iodepth  --size="$size" --numjobs=1 --group_reporting --minimal > $csvfilename
#	fi
#done
#
#
while [ 1 ]
do
iomode=$iomode2			
name="${iomode}_r70w30_${blocksize}_${iodepth}D"
if [ $nolog -eq 1 ]
then
	fio --name=$name --rw=$iomode --direct=1 --rwmixread=70 --rwmixwrite=30 --thread --runtime=$time --filename=$disktargets --bs=$blocksize --iodepth=$iodepth  --size=$size --numjobs=1 --group_reporting --minimal  
else
	fio --name=$name --rw=$iomode --direct=1 --rwmixread=70 --rwmixwrite=30 --thread --runtime=$time --filename=$disktargets --bs=$blocksize --iodepth=$iodepth  --size=$size --numjobs=1 --group_reporting --minimal  > $csvfilename
fi

iomode=$iomode2		
name="${iomode}_r30w70_${blocksize}_${iodepth}D"
if [ $nolog -eq 1 ]
then
	fio --name=$name --rw=$iomode --direct=1 --rwmixread=30 --rwmixwrite=70 --thread --runtime=$time --filename=$disktargets --bs=$blocksize --iodepth=$iodepth --size=$size --numjobs=1 --group_reporting --minimal  
else
	fio --name=$name --rw=$iomode --direct=1 --rwmixread=30 --rwmixwrite=70 --thread --runtime=$time --filename=$disktargets --bs=$blocksize --iodepth=$iodepth --size=$size --numjobs=1 --group_reporting --minimal  > $csvfilename
fi
done
