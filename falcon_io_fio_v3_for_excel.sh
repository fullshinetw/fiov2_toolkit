#!/bin/sh
# For fio v3.0.x benchmark script with Linux 3.10
# Author: phillips.hsieh@falconstor.com
# Version: 3.0
# ----------------------------------------------------------------------------
model=FalconStor
time=30s

while true
do
	case "$1" in
	-h | --help)
		echo "Parameter -target [you can specify a number of files by separating the names with a ‘:’ character]"
		echo "Parameter -size [It is also possible to give  size  as  a  percentage between 1 and 100. If size=20% is given, fio will use 20% of the full size of the given files or devices.]"
		echo "Example:"
		echo "$0 -target /dev/sd[n]:/dev/sd[m] -size 20%"
		exit 0
	;;
	-target)
		target=${2:-.}
		shift 2
	;;
	-size)
		size=${2:-.}
		shift 2
	;;
    	*)
		if [ -z $target ]  || [ -z $size ]
		then
			echo "Please -h for know more options"
			exit 1
		fi
	   	break ;;
	esac
done


# check fio version is v3
fiover=`fio -v| awk -F- '{print $2}'| awk -F. '{print $1}'`
if [ ${fiover} -lt 2 ]
then
	echo "please ensure this Linux have installed fio v3"
	exit 1
fi


# backup old csv file
if [ -f $model.Linux.fiov3.csv ]
then
	echo "move $model.Linux.fiov3.csv to old.$model.Linux.fiov3.csv"
	mv -f $model.Linux.fiov3.csv old.$model.Linux.fiov3.csv
fi

for iomode in read randread write randwrite 
do
	for block in 512b 4k 8k 16k 32k 64k 128k 256k 
	do
		for stream in 1 
		do
			for iodepth in 1 4 16 64 
			do
				name=${iomode}_${block}_${iodepth}D
				fio --name=$name --rw=${iomode}  --random_generator=tausworthe64 --direct=1 --ioengine=libaio --runtime=$time --size="$size"  --filename="$target" --bs=${block} --iodepth=${iodepth} --numjobs=$stream --group_reporting --minimal >> $model.Linux.fiov3.csv

			done #end queue depth
		done #end stream 
	done #end block size 
done # end iomode select


for iomode in randrw # read=70%,write=30%,rand=100%
do
	for block in 512b 4k 8k 16k 32k 64k 128k 256k 
	do
		for stream in 1 
		do
			for iodepth in 1 4 16 64 
			do
				name=${iomode}_r70w30_${block}_${iodepth}D
				fio --name=$name --rw=${iomode} --random_generator=tausworthe64 --direct=1 --ioengine=libaio --rwmixread=70 --rwmixwrite=30 --runtime=$time --size="$size"  --filename="$target" --bs=${block} --iodepth=${iodepth} --numjobs=$stream --group_reporting --minimal >> $model.Linux.fiov3.csv

			done #end queue depth
		done #end stream 
	done #end block size 
done # end iomode select

for iomode in randrw # read=30%,write=70%,rand=100%
do
	for block in 512b 4k 8k 16k 32k 64k 128k 256k 
	do
		for stream in 1 
		do
			for iodepth in 1 4 16 64 
			do
				name=${iomode}_r30w70_${block}_${iodepth}D
				fio --name=$name --rw=${iomode} --random_generator=tausworthe64  --direct=1 --ioengine=libaio --rwmixread=30 --rwmixwrite=70 --runtime=$time --size="$size"  --filename="$target" --bs=${block} --iodepth=${iodepth} --numjobs=$stream --group_reporting --minimal >> $model.Linux.fiov3.csv

			done #end queue depth
		done #end stream 
	done #end block size 
done # end iomode select


sed -i 's/;/,/g' $model.Linux.fiov3.csv
