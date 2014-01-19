#!/bin/bash
#
#
#log-parse
#
#searches bro's conn.log for the specified source IP address and outputs each if its unique
#connection's destination IP and port number. By default, log-parse displays each connection
#made from the address. A target port can be specified with -p, and an output file with -o.
#
#options -f, -t, -a, and a parsing option (currently -c) are needed.
#options -o and -p are optional.
#
#to do:
#
#1. add support for multiple log files
#2. add support for various parsing options
#3. ability to search multiple IP addresses
#4. ability to search multiple port numbers
#5. add support for ignoring connections of a specified port
#
#
#options:
#
#	-f  |  file path to conn.log
#	-t  |  type of log file
#	-a  |  source IP address
#	-o  |  output file
#	-c  |  parse connections (currently needed, and only parsing option)
#	-p  |  port
#
#
#log file types (specified by -t):
#
#	bro  |  search bro's conn.log
#
#
#usage:
#
#./log-parse.sh -t bro -f conn.log -a 192.168.15.4 -c
#./log-parse.sh -t bro -f conn.log -a 192.168.15.4 -p 80 -c -o http.txt
#
#


#variables
OUT=0
CONN=0
PORT=0

#get options

while getopts ":f:t:a:o:cp:" option; do
	case $option in
	 f)
	     FILE="$OPTARG"
	     ;;
	 t)
	     TYPE="$OPTARG"
	     ;;
	 a)
	     ADD="$OPTARG"
	     ;;
	 o)
	     OUT=1
	     OUTPUT="$OPTARG"
	     ;;
	 c)
	     CONN=1
	     ;;
	 p)
	     PORT=1
	     PNUM="$OPTARG"
	     ;;
	 :)
	     echo "option -$OPTARG requires an argument"
	     exit 1
	     ;;
	 *)
	     echo "invalid option -$OPTARG"
	     exit 1
	     ;;
	esac
done


#check for options and parse log accordingly	
	    
	
if [[ $TYPE == bro ]]; then
	if [[ $CONN == 1 && $OUT == 1 && $PORT == 1 ]]; then
		bro-cut id.orig_h id.resp_h id.resp_p < $FILE | awk -v add=${ADD} -v pnum=${PNUM} \
		'$1 == add && $3 == pnum {print $2,"\t",$3}' | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n \
		| uniq > $OUTPUT

		echo "output saved to $OUTPUT"

	elif [[ $CONN == 1 && $PORT == 1 ]]; then
		bro-cut id.orig_h id.resp_h id.resp_p < $FILE | awk -v add=${ADD} -v pnum=${PNUM} \
		'$1 == add && $3 == pnum {print $2,"\t",$3}' | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n \
		| uniq 	

	elif [[ $CONN == 1 && $OUT == 1 ]]; then
		bro-cut id.orig_h id.resp_h id.resp_p < $FILE | awk -v add=${ADD} '$1 == add {print $2,"\t",$3}' \
		| sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | uniq > $OUTPUT

		echo "output saved to $OUTPUT"
	
	elif [[ $CONN = 1 && $OUT = 0 ]]; then

		bro-cut id.orig_h id.resp_h id.resp_p < $FILE | awk -v add=${ADD} '$1 == add {print $2,"\t",$3}' \
                | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | uniq
	fi
fi
