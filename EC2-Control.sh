#!/bin/sh
 
DEFAULT_REGION='us-east-1'
INSTANCE_ID='i-xxxxxxxx'
echo ""
echo "instance-id:["$INSTANCE_ID"]"
 
## 指定インスタンスのステータス確認(aws ec2 describe-instance-status)
INSTANCE_STATUS=`aws ec2 describe-instance-status --instance-ids $INSTANCE_ID --region $DEFAULT_REGION | jq -r '.InstanceStatuses[].InstanceState.Name'`
echo "instance-status:["$INSTANCE_STATUS"]"
 
## 指定EC2インスタンスの起動(aws ec2 start-instances).
if [ -n "$1" ] && [ $1 = '--start' ] ; then
 
    if [ -n "$INSTANCE_STATUS" ] && [ $INSTANCE_STATUS = 'running' ] ; then
        ## 稼働中であれば特に何もしない.
        echo "status is running. nothing to do."
    else
        ## 停止中であれば起動指示.
        echo "status is stopped."
        aws ec2 start-instances --instance-ids $INSTANCE_ID --region $DEFAULT_REGION
        echo "ec2 instance starting..."
    fi
 
## 指定EC2インスタンスの停止(stop). 
elif [ -n "$1" ] && [ $1 = '--stop' ] ; then
 
    if [ -n "$INSTANCE_STATUS" ] && [ $INSTANCE_STATUS = 'running' ] ; then
        ## 稼働中であれば停止指示.
        echo "status is running."
        aws ec2 stop-instances --instance-ids $INSTANCE_ID --region $DEFAULT_REGION
        echo "ec2-instance stopping..."
    else
        ## 停止中であれば何もしない.
        echo "status is stopped. nothing to do."
    fi
 
## 引数無しの場合は何もしない.
else
    if [ -z "$1" ] ; then
        echo "argument is required( --start / --stop ). nothing to do."
    else
        echo "argument is invalid. valid argument is --start or --stop."
    fi
fi
echo ""