pid="$1"
sudo strace -p $pid -o log.$pid
