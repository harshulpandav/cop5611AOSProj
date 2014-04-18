# Get a list of pids
while [ 1 ] #loop forever
do
	echo "Woke up!														[OK]"
	#get list of running processes
	echo "Generating file containing running processes					[OK]"
	sudo ps -eo pid,command | grep -v grep | awk '{print $1}' > pids.txt
	echo "Generated file containing running processes					[OK]"
	#delete the first line
	sed '/PID/d' pids.txt > temp.txt ; mv temp.txt pids.txt

	#create a file which will be populated with the processes to be run
	> toRun.txt
	
	#create the file if does not exist
	if [ ! -f procRunning.txt ]; then
    	> procRunning.txt
	fi 

	#for each line in pids.txt
	while read -r line1
	do
		exists=true
		if grep -Fxq "$line1" procRunning.txt
			then
   		 		exists=true
			else
    			exists=false
		fi
		comm=$(sudo ps $line1 | grep -v grep | awk '{print $5}' | sed 1d) 
		#echo $comm
		#echo $exists
		if [ "$exists" = false ] && [ "$comm" != "bash" -a "$comm" != "strace" -a  "$comm" != "sudo" ]
			then
		    	echo "$line1" >> procRunning.txt
		    	echo "$line1" >> toRun.txt
		fi
	done < pids.txt
	echo "Generated file containing processes to strace					[OK]"
	echo "Generated file containing processes currently being straced	[OK]"
#	filename="$1"
	while read -r line
	do
		chmod +x straceProgram.sh
		./straceProgram.sh $line &
	done < toRun.txt
	#echo $name
	#sudo strace $name -o output5.txt
	#
	echo "Sleeping for one minute ..zzz...								[OK]"
	sleep 60
	
done