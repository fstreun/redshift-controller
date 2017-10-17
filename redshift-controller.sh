#!/bin/bash

file="/tmp/redshift-controller"

REDSHIFTMAX=25000
REDSHIFTMIN=1000

STEPDEFAULT=200

# This allows us to change its appearance conditionally
icon=""

# Sets the global variable currenttemp to the current temperature
getCurrentTemp(){
  pgrep -x redshift &> /dev/null
  if [[ $? -eq 0 ]]; then
    # redshift is running
    currenttemp=$(redshift -p 2>/dev/null | grep temp | cut -d' ' -f3)
    currenttemp=${currenttemp//K/}
  else
    # no redshift running
    # maybe value is in the tmp file
    currenttemp=$(<$file)
  fi
}

# Sets temperature to the argument.
# Only checks if an argument is given
# and not if it's in the correct range
setTemp(){
  if [[ -z "$1" ]]; then
    echo "ERROR: setTemp(): need an argument"
    exit 1
  else
    temp=$1
    pgrep -x redshift &> /dev/null
    if [[ $? -eq 0 ]]; then
      # redshift is running
      killall -q redshift
    fi
    setFileTemp $temp
    redshift -O $temp
  fi
}

# Resets redshift to the default configurations.
# (probably defined in the config file)
reset(){
  pgrep -x redshift &> /dev/null
  if [[ $? -ne 0 ]]; then
    redshift -x
    redshift -r &
  fi
  echo '' > $file
}

setFileTemp(){
  echo $1 > $file
}

# Increases the temperature to the next multiple of the value
# of the first argument (or STEPDEFAULT).
# But stops at the REDSHIFTMAX
increase(){
  if [[ -z "$1" ]]; then
    amount=$STEPDEFAULT
  else
    amount=$1
  fi

  getCurrentTemp
  if ((currenttemp % amount == 0)); then

    newtemp=$((currenttemp+amount))
  else

    newtemp=$((currenttemp + amount - (currenttemp % amount)))
  fi

  if ((newtemp > REDSHIFTMAX)); then
    # reached max
    newtemp=$REDSHIFTMAX
  elif ((newtemp < REDSHIFTMIN)); then
    # reached min
    newtemp=$REDSHIFTMIN
  fi
  setTemp $newtemp
}

# Decreases the temperature to the next multiple of the value
# of the first argument (or STEPDEFAULT).
# But stops at the REDSHIFTMIN
decrease(){
  if [[ -z "$1" ]]; then
    amount=$STEPDEFAULT
  else
    amount=$1
  fi

  getCurrentTemp
  if ((currenttemp % amount == 0)); then

    newtemp=$((currenttemp-amount))
  else

    newtemp=$((currenttemp - (currenttemp % amount)))
  fi

  if ((newtemp < REDSHIFTMIN)); then
    # reached min
    newtemp=$REDSHIFTMIN
  elif ((newtemp > REDSHIFTMAX)); then
    # reached min
    newtemp=$REDSHIFTMAX
  fi
  setTemp $newtemp
}

# Returns (echo) the temperature with icon
# (depending how it is defined)
printTemperature(){
  getCurrentTemp
  # define output Format here
  if [[ -z $currenttemp ]]; then
    # no current temperature (probably not running)
    # Grey
    echo "%{F#474C55}$icon"
  elif [[ $temp -ge 5000 ]]; then
    # Blue
    echo "%{F#73CEFF}$icon ${currenttemp}K"
  elif [[ $temp -ge 4000 ]]; then
    # Yellow
    echo "%{F#FFF365}$icon ${currenttemp}K"
  else
    # Orange
    echo "%{F#FF9B1E}$icon ${currenttemp}K"
  fi
}

# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
elif [[ -z "$1" ]]; then
  # emtpy argument
    echo "usage only with function name" >&2
else
  # Show a helpful error
  echo "'$1' is not a known function name" >&2
  echo "usage only with function name" >&2
  exit 1
fi
