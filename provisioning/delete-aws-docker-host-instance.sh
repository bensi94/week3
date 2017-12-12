#Here we use our parameter id as folder we
INSTANCE_DIR=$1

#We only try to delete if the local directory exists
if [ -d "${INSTANCE_DIR}" ]; then
    # Get our instance id
    INSTANCE_ID=$1
    # Get our KEY_PAIR_NAME from the local directory
    KEY_PAIR_NAME=$(cat ./$INSTANCE_DIR/key-pair-name.txt)

    # terminate the instance using the instnace_id
    aws ec2 terminate-instances --instance-ids ${INSTANCE_ID}

    # let the script wait until the instance is terminated so it can delete the key pair successfully
    aws ec2 wait --region eu-west-2 instance-terminated --instance-ids ${INSTANCE_ID}

    aws ec2 delete-key-pair --key-name ${KEY_PAIR_NAME}

    #Remove the directory from local
    sudo rm  -rf $INSTANCE_DIR
fi
