INSTANCE_ID=$1
GIT_COMMIT=$2

# Using the Instance ID we get the public link to the website so we can use it in the scp and ssh, also get the keypair name to use the right .pem file
INSTANCE_PUBLIC_NAME=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[*].Instances[*].PublicDnsName" --output=text)
KEY_PAIR_NAME=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[*].Instances[*].KeyName" --output=text)

# In the while loop we make sure that we can ssh into the server before doing some commands on it
status='unknown'
while [ ! "${status}" == "ok" ]
do
   status=$(ssh -i "~/runningInstances/${INSTANCE_ID}/${KEY_PAIR_NAME}.pem"  -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 ec2-user@${INSTANCE_PUBLIC_NAME} echo ok 2>&1)
   sleep 2
done

hostInstance=$(aws ec2 describe-instances --filters "Name=key-name, Values=bensiKeyPair_0" --query Reservations[*].Instances[*].PublicDnsName --output=text)

#We copy the files we need too the server
scp -o StrictHostKeyChecking=no -i "~/runningInstances/$INSTANCE_ID/${KEY_PAIR_NAME}.pem" ./ec2-instance-check.sh ec2-user@${INSTANCE_PUBLIC_NAME}:~/ec2-instance-check.sh
scp -o StrictHostKeyChecking=no -i "~/runningInstances/$INSTANCE_ID/${KEY_PAIR_NAME}.pem" ./docker-compose.yaml ec2-user@${INSTANCE_PUBLIC_NAME}:~/docker-compose.yaml
scp -o StrictHostKeyChecking=no -i "~/runningInstances/$INSTANCE_ID/${KEY_PAIR_NAME}.pem" ./docker-compose-and-run.sh ec2-user@${INSTANCE_PUBLIC_NAME}:~/docker-compose-and-run.sh
scp -o StrictHostKeyChecking=no -i "~/runningInstances/$INSTANCE_ID/${KEY_PAIR_NAME}.pem" ./datadog-deploy-event.sh ec2-user@${INSTANCE_PUBLIC_NAME}:~/datadog-deploy-event.sh

#Change the permissons so we can run the script on the sever, then we run it and compose the application from the docker-compose.yml file
ssh -o StrictHostKeyChecking=no -i "~/runningInstances/$INSTANCE_ID/${KEY_PAIR_NAME}.pem" ec2-user@${INSTANCE_PUBLIC_NAME} "chmod +x ~/docker-compose-and-run.sh"
ssh -o StrictHostKeyChecking=no -i "~/runningInstances/$INSTANCE_ID/${KEY_PAIR_NAME}.pem" ec2-user@${INSTANCE_PUBLIC_NAME} "~/docker-compose-and-run.sh $GIT_COMMIT"
ssh -o StrictHostKeyChecking=no -i "~/runningInstances/$INSTANCE_ID/${KEY_PAIR_NAME}.pem" ec2-user@${INSTANCE_PUBLIC_NAME} "chmod +x ~/datadog-deploy-event.sh"
ssh -o StrictHostKeyChecking=no -i "~/runningInstances/$INSTANCE_ID/${KEY_PAIR_NAME}.pem" ec2-user@${INSTANCE_PUBLIC_NAME} "~/datadog-deploy-event.sh $hostInstance"
