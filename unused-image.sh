#!/bin/sh

PROGNAME=$(basename "$0")
PROGDIR=$(dirname "$0")

usage() 
{
	echo "Usage: $PROGNAME  [-r] path-of-project"
	echo ""
	echo "-r          Remove unused image file"
	exit 1
}

PRJ_ROOT=./
REMOVE=false
COUNT=0

if [ $# -eq 1 ] ; then
	PRJ_ROOT=$1
elif [ $# -eq 2 ]; then
	if [ $1 -eq "-r"]; then
		REMOVE=true
		PRJ_ROOT=$2
	elif [$2 -eq "-r"]; then
		REMOVE=true
		PRJ_ROOT=$1
	else
		usage
	fi

else
	usage; 
fi

check_files=`find $PRJ_ROOT -name '*.xib' -o -name '*.[mh]' -o -name '*.java' -o -name '*.xml'`

for png in `find $PRJ_ROOT -name '*.png'`
do
    match_name=`basename $png`
    
    suffix1="@2x.png"
    suffix2=".9.png"
    suffix3=".png"
    
   	if [[ ${match_name/${suffix1}//} != $match_name ]]; then
   		match_name=${match_name%$suffix1}
   	elif [[ ${match_name/${suffix2}//} != $match_name ]]; then
   		match_name=${match_name%$suffix2}
    else
    	match_name=${match_name%$suffix3}
    fi	

    referenced=false

    for file  in `echo $check_files | sed 's/\n/ /g'`  
	do   
	    if  grep -sqh "$match_name" "$file"; then
	        referenced=true
	    fi
	done  

	if ! $referenced ; then
		echo "The '$png' was not referenced in any file"
		COUNT=`expr $COUNT + 1`
	fi

done

echo "============= Total $COUNT unused image files ============="
