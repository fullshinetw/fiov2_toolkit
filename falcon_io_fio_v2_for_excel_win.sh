#
# For fio v2.0.x benchmark script with Windows x86
# Author: phillips.hsieh@falconstor.com
# Version: 1.0
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
		echo "$0 -target \\.\PhysicalDrive1:\\.\PhysicalDrive2 -size 20%"
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

# backup old csv file
if [ -f $model.Windowsx86.fiov2.csv ]
then
	echo "move $model.Windowsx86.fiov2.csv to old.$model.Windowsx86.fiov2.csv"
	mv -f $model.Windowsx86.fiov2.csv old.$model.Windowsx86.fiov2.csv
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
				fio --name=$name --rw=${iomode}  --direct=1 --ioengine=windowsaio --thread --runtime=$time --filename="$target" --size="$size" --bs=${block} --iodepth=${iodepth} --numjobs=$stream --group_reporting --minimal >> $model.Windowsx86.fiov2.csv
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
				fio --name=$name --rw=${iomode}  --direct=1 --ioengine=windowsaio --thread --rwmixread=70 --rwmixwrite=30 --runtime=$time --filename="$target" --bs=${block} --iodepth=${iodepth} --size="$size" --numjobs=$stream --group_reporting --minimal >> $model.Windowsx86.fiov2.csv
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
				fio --name=$name --rw=${iomode}  --direct=1 --ioengine=windowsaio --thread --rwmixread=30 --rwmixwrite=70 --runtime=$time --filename="$target" --bs=${block} --iodepth=${iodepth} --size="$size" --numjobs=$stream --group_reporting --minimal >> $model.Windowsx86.fiov2.csv
			done #end queue depth
		done #end stream 
	done #end block size 
done # end iomode select

sed -i 's/;/,/g' $model.Windowsx86.fiov2.csv
