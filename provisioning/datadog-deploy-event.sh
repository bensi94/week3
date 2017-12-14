#!/bin/sh

link=$(aws ec2 describe-instances --filters "Name=key-name, Values=bensiKeyPair_0" --query Reservations[*].Instances[*].PublicDnsName --output=text)
port=":8080"
returnLink="http://$link$port"

curl  -X POST -H "Content-type: application/json" \
-d '{
      "title": "New production deployment from Jenkins",
      "text": "'"$returnLink"'",
      "priority": "normal",
      "tags": ["environment:test"],
      "alert_type": "info",
      "icon":"https://uploads.toptal.io/blog/category/logo/291/react.png"
  }' \
'https://app.datadoghq.com/api/v1/events?api_key=21246412d7606d42cbcb056a409052af'
