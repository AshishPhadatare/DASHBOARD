#!/bin/bash
#Purpose: CMSIT monitoring dashboard
#Author: Ashish Phadatare

echo "LAYER,USER,IP,SSH_CONN,MAIN_AVAIL,MAIN_USED" > input.csv
for value in `cat Env_Config.conf | sed '1d'`
    do
        ENV='CMSIT'
        LAYER=`echo $value | awk -F ',' '{print $1}'`
        IP=`echo $value | awk -F ',' '{print $2}'`
        USER=`echo $value | awk -F ',' '{print $3}'`
        DEVPATH=`echo $value | awk -F',' '{print $5}'`
        ssh -o ConnectTimeout=3 $USER@$IP exit
            if [ $? -eq 0 ] ; then
            SSH_CONN='Up'
            MAIN_AVAIL=`ssh $USER@$IP "cd $DEVPATH/.. ; df -kh . | tail -1 | awk -F' ' '{print $4}'"`
            MAIN_AVAIL=`echo $MAIN_AVAIL | awk -F' ' '{print $4}'`
            MAIN_USED=`ssh $USER@$IP "cd $DEVPATH/.. ; df -kh . | tail -1 | awk -F' ' '{print $5}'"`
            MAIN_USED=`echo $MAIN_USED | awk -F' ' '{print $5}' | sed 's/ //g'`
            MAIN_USED=`echo $MAIN_USED | sed 's/%//g'`
            echo ""$LAYER","$USER","$IP","$SSH_CONN","$MAIN_AVAIL","$MAIN_USED"" >> input.csv
            else
            SSH_CONN='Down'
            MAIN_AVAIL='NA'
            MAIN_USED='NA'            
            echo ""$LAYER","$USER","$IP","$SSH_CONN","$MAIN_AVAIL","$MAIN_USED"" >> input.csv
            fi
    done
   
sed -i '1d' input.csv
python csv_to_json.py
    if [ $? -eq 0 ] ; then
    rm -rf input.csv
    else
    rm -rf input.csv
    fi