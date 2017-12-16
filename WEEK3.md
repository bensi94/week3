# Week 3 Assignment

## Links and info

- [Jenkins Link](http://ec2-35-176-106-179.eu-west-2.compute.amazonaws.com:8080/)
Login credentials are in comment on Canvas.

- [Live working TicTacToe instance](http://ec2-35-177-133-99.eu-west-2.compute.amazonaws.com:8080/)

- [Datadog Dashboard](https://p.datadoghq.com/sb/e5b0bec5b-935b727242)



## List of things finished:

#### Database migrations

For the database migrations I created a up migration that adds the column *aggregate_id* to table *eventlog* and another down migration to remove the column.

#### On Git push Jenkins pulls my code and the Tic Tac Toe application is deployed through a build pipeline

Everything in the build Pipeline should be working, and it fails if test fail. I'm using Github webhook to push to jenkins.

Jenkins also has a second job that runs every morning at 03:00 and cleans all docker containers.

####  Filled out the Assignments: for the API and Load tests

My answers to the questions can be found in assignment.md in this repository

#### The API and Load test run in my build pipeline on Jenkins and everything is cleaned up afterwards

The test are run on the jenkins instance in the pipeline, and the process killed after running. And the postgres continer is also killed after the tests.

#### My test reports are published in Jenkins

My reports can be found in each build under test results and Jenkins also shows Test results Trend in the pipeline.

#### My Tic Tac Toe game works, two people can play a game till the end and be notified who won.

Everything seems to work here.

#### My TicCell is tested

Tests for the ticCell should be fully implemented.

#### I've set up Datadog

Datadog has been set up and is show cpu, ram, docker containers, network in for both production and jenkins server. I also have a script that uses the datadog api to post an event when there is new version deployed on the production server, the event also shows a public address to the instance, and this is shown in the event stream on datadog dashboard.
