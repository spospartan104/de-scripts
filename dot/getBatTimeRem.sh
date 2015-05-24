#!/bin/bash
# If set to 1 assumes power info is in sys dir, else assumes /proc
sysOrproc=1
if [[ "$1" == "sys" || "$sysOrproc" == 1 ]]; then
  rateNow=`cat /sys/class/power_supply/BAT0/current_now`
  lastFullCap=`cat /sys/class/power_supply/BAT0/charge_full`
  capRem=`cat /sys/class/power_supply/BAT0/charge_now`
  state=`cat /sys/class/power_supply/BAT0/status`
  stateToPrint=""
  is_full=`echo $capRem - $lastFullCap | bc -l`
  if [[ "$state" == "Unknown" || "$state" == "Full" || $is_full -eq 0 ]]; then
    #If unknown it usually means full or missing
    timeFract=1
    stateToPrint='F'
  elif [ "$state" == "Charging" ]; then
    #Time Remaining for charge aproxx
    timeFract=`echo "($lastFullCap - $capRem) / $rateNow" | bc -l`
    stateToPrint='C'
  else
    #time Remaining for Battery Discharge approx
    timeFract=`echo "$capRem / $rateNow" | bc -l`
    stateToPrint='d'
  fi

  if [[ "$stateToPrint" == "F" ]]; then
    printf "Batt Full!"
  else
    hours=`echo "$timeFract / 1" | bc `
    minRemFract=`echo "$timeFract - $hours" | bc -l `
    min=`echo "$minRemFract * 60" | bc  `
    printf "%s %dh:%.2fm" $stateToPrint $hours $min
  fi
else
  rateNow=`cat /proc/acpi/battery/BAT0/state| grep "rate" | awk '{print $3}'`
  lastFullCap=`cat /proc/acpi/battery/BAT0/info | grep "last full" | awk '{print $4}'`
  capRem=`cat /proc/acpi/battery/BAT0/state| grep "remaining capacity" | awk '{print $3}'`
  state=`cat /proc/acpi/battery/BAT0/state|grep "charging state"|awk '{print $3}'`
  stateToPrint=""
  if [ "$state" == "charging" ]; then
    timeFract=`echo "($lastFullCap - $capRem) / $rateNow" | bc -l`
    stateToPrint='c'
  else
    timeFract=`echo "$capRem / $rateNow" | bc -l`
    stateToPrint='d'
  fi
  hours=`echo "$timeFract / 1" | bc `
  minRemFract=`echo "$timeFract - $hours" | bc -l `
  min=`echo "$minRemFract * 60 -15" | bc  `
  printf "%s %dh:%.2fm" $stateToPrint $hours $min
fi
