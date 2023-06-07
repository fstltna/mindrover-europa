#!/bin/sh
#
# This is a script to recompile your existing vehicles

# Function to find the real directory a program resides in.
# Feb. 17, 2000 - Sam Lantinga, Loki Entertainment Software
FindPath()
{
    fullpath="`echo $1 | grep /`"
    if [ "$fullpath" = "" ]; then
        oIFS="$IFS"
        IFS=:
        for path in $PATH
        do if [ -x "$path/$1" ]; then
               if [ "$path" = "" ]; then
                   path="."
               fi
               fullpath="$path/$1"
               break
           fi
        done
        IFS="$oIFS"
    fi
    if [ "$fullpath" = "" ]; then
        fullpath="$1"
    fi
    # Is the awk/ls magic portable?
    if [ -L "$fullpath" ]; then
        fullpath="`ls -l "$fullpath" | awk '{print $11}'`"
    fi
    dirname $fullpath
}

# Get the regen executable
cd "`FindPath $0`"
regen="`pwd`/regen"

# Make sure we can get to the vehicles directory
vehicles="$HOME/.loki/mindrover/Vehicles/$USER"
if [ ! -d "$vehicles" ]; then
    echo "You must play MindRover at least once before running this script"
    exit 1
fi
cd "$vehicles"

if [ "$1" = "" ]; then
echo "This script recompiles saved user vehicles.  It is particularly useful"
echo "when you see messages to the effect that a particular vehicle is"
echo "INCOMPATIBLE and must be recompiled."
echo ""
echo "Usage: $0 vehicle1 [vehicle2 ...]"
echo "where vehicle1, etc., are names of vehicles you've built."
echo "Any of the vehicle names can be specified with wildcards,"
echo "e.g. \"*Hover*\""
echo "To process all of your vehicles, just use: $0 \"*\""
    exit 1
fi

for vehicle in $*
do nowst=`basename $vehicle .wst`
   if [ "$vehicle" != "$nowst" ]; then # This is a vehicle file
        $regen text/codegen.mac ./$vehicle
   fi
done
exit 0
