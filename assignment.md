# Api and load tests assignment

This is the assignment from Day 11, about api and load tests.

### Assignment 1

*Assignment: Find appropriate numbers to configure the load test so it passes on your buildserver under normal load.*

I tried out a lot of different numbers for the load testing parameters. I found out that 100 games in 10 seconds would be reasonable numbers. For example it failed when the count went up too 200 games in 10 seconds.


### Assignment 2

*Assignment: Run load tests. See them succeed a couple of times.
            Move expectMoveMade() and expectGameJoined() after joinGame() call, and expectGameCreated() after createGame() call
            like this:
                 userB.joinGame(userA.getGame().gameId).expectMoveMade('X').expectGameJoined().then(function () {*


It seams like this changes does not do much difference too the result of the load tests how ever I change the combination. They fail on same values and pass on same values. But I think the reason why they could fail is because of they are set up with promises functionality for the asynchronous activity, so if something would take too long the wrong order of the calls would make the test fail.

### Assignment 3

*Assignment: Explain how this apparently sequential code can function to play two sides of the game.*

It uses the expect promises to and pushes them to a stack like array, so implemented in the right order it makes sure that the right functions always wait for the right functions to finish before running a function. So this way we can make sure that everything happens in the right order an we can play both sides of the game. For example functions to make a move always wait for the move from the other player to finish before running.


### Assignment 4

*Put in log statements that enable you to trace the messages going back and forth. Result is a list of modules/functions in this source code which get invoked when cleanDatabase is called.*

What this function does for us is to make sure that before we run the the api and load tests we clean out all previous events by deleting everything from eventlog and everything from the commandlog. And this uses kind of a backdoor to the database to get in and do the tests.

This happens before every single API test and load test and uses promises to wait for the clean job to finish.

### Assignment 5

*Assignment: Explain what the push/pop functions do for this API. What effect would it have on the fluent API if we did not have them?*

How this works is we make a stack of events that the promises need to wait for so this makes sure that they happen and come back in right order. So when we expect a event to finish we push it on to the stack and then we can just push next and next event on to it, so when it traces back and pops everything off on the way back it's always made sure that the event that needed to happen before an event actually occurred.

If we would not do it in this way we would have to write the code that uses the api just line by line where we can not tell it what event should happen next until the one before is done. So the code would probably be much more complex and much more of it.
