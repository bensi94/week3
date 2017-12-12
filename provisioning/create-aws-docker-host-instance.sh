INSTANCE_DIR="ec2_instance"
#this is the standar securityGroup name I use
SECURITY_GROUP_NAME="bensi94-securityGroup"

#Start by making directory where the keypair.pem file, instance-id, and more info about the instance will be stored locally
[ -d "${INSTANCE_DIR}" ] || mkdir ${INSTANCE_DIR}

#This is my initial keypair name but I start by asking AWS if that already exist and then I change it in the while loop until I find a free one
KEY_PAIR_NAME="bensiKeyPair_0"
keyPairExists=$(aws ec2 describe-key-pairs --query KeyPairs[*].KeyName --output=text)
i=1
while [[ $keyPairExists == *$KEY_PAIR_NAME* ]]; do
    KEY_PAIR_NAME="bensiKeyPair_$i"
    ((i++))
done

#Then I make a key-pair and save the pem key file to local host
aws ec2 create-key-pair --key-name ${KEY_PAIR_NAME} --query 'KeyMaterial' --output text > ${INSTANCE_DIR}/${KEY_PAIR_NAME}.pem
chmod 400 ${INSTANCE_DIR}/${KEY_PAIR_NAME}.pem

#Here I check if the standard securityGroup exists on AWS (Should be always except the first time or it's deleted)  I use the same security group for all instances
sgExists=$(aws ec2 describe-security-groups --group-names $SECURITY_GROUP_NAME 2>&1)
if [[ $sgExists == *"InvalidGroup.NotFound"* ]]; then

    #If it does not exists we make a new securityGroup
    SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name ${SECURITY_GROUP_NAME} --description "security group for dev environment in EC2" --query "GroupId"  --output=text)

    #Make the protocol acessable from anywhere
    aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 80 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 22 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP_NAME} --protocol tcp --port 8080 --cidr 0.0.0.0/0
else
    #If the security group alredy exists we just gets its ID
    SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --group-names bensi94-securityGroup --query "SecurityGroups[*].GroupId" --output=text)
fi

#save the KEY_PAIR_NAME and SECURITY_GROUP_ID to localhost
echo ${KEY_PAIR_NAME} > ./ec2_instance/key-pair-name.txt
echo ${SECURITY_GROUP_ID} > ./ec2_instance/security-group-id.txt

#Here we make the actual instance and run some start up commands on it from ec2-instance-init where docker and more is installed, and we get the instanceID as well
INSTANCE_ID=$(aws ec2 run-instances --user-data file://docker-instance-init.sh --image-id ami-e7d6c983 --security-group-ids ${SECURITY_GROUP_ID} --count 1 --instance-type t2.micro --key-name ${KEY_PAIR_NAME} --query 'Instances[0].InstanceId'  --output=text)

#change the name of the local directory to the INSTANCE_ID so we can keep many instance directories and organize them
mv ec2_instance $INSTANCE_ID

#save the instance to localhost
echo ${INSTANCE_ID} > ./$INSTANCE_ID/instance-id.txt

#copy to keep this between builds
test -d ~/runningInstances/ || mkdir -p ~/runningInstances
cp -R $INSTANCE_ID ~/runningInstances/$INSTANCE_ID

if [ ! -f ~/runningInstances/delete-aws-docker-host-instance.sh ]; then
    cp delete-aws-docker-host-instance.sh ~/runningInstances/
fi
