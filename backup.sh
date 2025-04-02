#! /bin/bash

today=$(date +%Y-%m-%d) # date 2025-3-22
weekday=$(date +%u) #weekday 1-monday .. 
day_of_month=$(date +%d) # number dayte 1,2, .. 30,31 

date_for_name_file=$(date +'%d.%m.%Y_%H.%M') 
FILENAME=$base_dir/$(hostname)_$date_for_name_file 

# directory for backups
base_dir=/backup # Directory base
dayly_dir="$base_dir/daily"
weekly_dir="$base_dir/weekly"
monthly_dir="$base_dir/monthly"

# Creat directory
sudo mkdir -p $base_dir $dayly_dir $weekly_dir $monthly_dir

# Backup

if [ $day_of_month -eq 1 ];then # first day of month
    sudo tar -cvzf $monthly_dir/$FILENAME.tar.gz -C /home/vitaliy/scripts .&> /dev/null
elif [ "$weekday" -eq 5 ];then # End work-weekday Fridey
    sudo tar -cvzf $weekly_dir/$FILENAME.tar.gz -C /home/vitaliy/scripts .&> /dev/null
    sudo tar -cvzf $weekly_dir/$FILENAME.tar.gz -C /home/vitaliy/.vim .&> /dev/null
    sudo tar -cvzf $weekly_dir/$FILENAME.tar.gz -C /home/vitaliy/.bashrc .&> /dev/null
else
    sudo tar -cvzf $dayly_dir/$FILENAME.tar.gz -C /home/vitaliy/scripts .&> /dev/null
fi

# Delete mounthly copy old 180 day
sudo find "$monthly_dir" -type f -name "*.tar.gz" -mtime +180 -exec rm -rf {} \;

# Delete archive weekday old 30 day
sudo find "$weekly_dir" -type f -name "*.tar.gz" -mtime +30 -exec rm -rf {} \;

# Delete archive day old 7 day
sudo find "$dayly_dir" -type f -name "*.tar.gz" -mtime +7 -exec rm -rf {} \;
