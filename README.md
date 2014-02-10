

log-parse searches bro's conn.log for the specified source IP address then outputs
each of the unique connections listing the destination IP and port number.
By default, log-parse displays each connection made from the address.
A target port can be specified with -p, and an output file with -o.

options -f, -t, -a, and a parsing option (currently -c) are required.
options -o and -p are optional.

to do:

1. add support for multiple log files
2. add support for various parsing options
3. ability to search multiple IP addresses
4. ability to search multiple port numbers
5. add support for ignoring connections of a specified port


options:

       -f  |  file path to conn.log
       -t  |  type of log file
       -a  |  source IP address
       -o  |  output file
       -c  |  parse connections (currently needed, and only parsing option)
       -p  |  port


log file types (specified by -t):

       bro  |  search bro's conn.log


usage:

./log-parse.sh -t bro -f conn.log -a 192.168.15.4 -c
./log-parse.sh -t bro -f conn.log -a 192.168.15.4 -p 80 -c -o http.txt

