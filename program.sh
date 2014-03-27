filename="$1"
while read -r line
do
#if [ $line == "PID" ]; then echo 1
#if [ $line >= 1500]; then
 name="$name -p $line "
#fi
done < "$filename"
#echo $name
sudo strace $name -o output5.txt
