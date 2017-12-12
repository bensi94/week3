EXTRA_INSTANCE=$1
NUMBER_OF_DIRECTORIES=$(ls -l ~/runningInstances | grep -c ^d)
if [[ $EXTRA_INSTANCE == '-extra' || $EXTRA_INSTANCE == '-e' || $NUMBER_OF_DIRECTORIES == 0 ]]; then

    #Create instance
    ./create-aws-docker-host-instance.sh

    #Get the directory we just made
    INSTANCE_ID=$(ls -lt ~/runningInstances | grep  ^d -m 1 | rev | cut -d ' ' -f 1 | rev)

else
    #Get the oldest directory
    INSTANCE_ID=$(ls -lrt ~/runningInstances | grep  ^d -m 1 | rev | cut -d ' ' -f 1 | rev)
fi

echo 'Instance ID:' $INSTANCE_ID

GIT_COMMIT=$(cat ../build/githash.txt)

./deploy-on-instance.sh $INSTANCE_ID  $GIT_COMMIT
