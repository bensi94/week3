const io = require('socket.io-client');
const RoutingContext = require('../client/src/routing-context');
let UserAPI = require('./fluentapi/user-api');
let TestAPI = require('./fluentapi/test-api');

const userAPI = UserAPI(inject({
    io,
    RoutingContext
}));

const testAPI = TestAPI(inject({
    io,
    RoutingContext
}));

describe('User chat API', function(){
    let user;

    beforeEach(function(done){
        let testapi = testAPI();
        testapi.waitForCleanDatabase(
            function(){
//                console.debug("Database has been cleared for testing");
            }
        ).cleanDatabase().then(()=>{
            testapi.disconnect();
            user = userAPI.create();
            done();
        });
    });

    afterEach(function(){
        user.disconnect();
    });

    it('should get user session information on connect',function(done){
        // There is a weak race condition here beacuse we have to wait for the asynchronous call to finish
        // Before we can determine the result
        user.expectUserAck().then(done);
    });

    it('should receive chat message back after sending chat command',function(done){
        // There is no race condition here beacuse this is asynchronous calls
        //and we have to make sure the message sends to the chat before we can finish the function
        user.expectChatMessageReceived('message one ')
            .sendChatMessage('message one ')
            .then(done);
    });

});
