#!/bin/sh

link=$1
port=":8080"
returnLink="http://$link$port"

curl  -X POST -H "Content-type: application/json" \
-d '{
      "title": "New production deployment from Jenkins of TicTacToe",
      "text": "Available now at: '"$returnLink"'",
      "priority": "normal",
      "tags": ["environment:production", "deployment", "TicTacToe"],
      "alert_type": "info"
  }' \
'https://app.datadoghq.com/api/v1/events?api_key=21246412d7606d42cbcb056a409052af'
