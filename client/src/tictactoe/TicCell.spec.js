import React from 'react';
import { shallow } from 'enzyme';

import TicCellComponent from './TicCell';


import MessageRouter from '../common/framework/message-router';


describe("Tic Cell", function () {

    let div, component, TicCell;

    let commandRouter = MessageRouter(inject({}));
    let eventRouter = MessageRouter(inject({}));
    let commandsReceived=[];

    commandRouter.on("*", function(cmd){
        commandsReceived.push(cmd);
    } );

    beforeEach(function () {
        //Need to reset the MessageRouter before each test
        eventRouter = MessageRouter(inject({}));
        commandRouter = MessageRouter(inject({}));
        commandsReceived.length=0;
        TicCell = TicCellComponent(inject({
            generateUUID:()=>{
                return "youyouid"
            },
            commandPort: commandRouter,
            eventRouter
        }));

        div = document.createElement('div');

        component = shallow(<TicCell coordinates={{x:1,y:2}} gameId="thegame" />, div);
    });

    function given() {
        //noinspection JSUnusedAssignment
        let side, xy, gameId="thegame";
        let api = {
            side(aside){
                side = aside;
                return api;
            },
            gameId(agameId){
                gameId=agameId;
                return api;
            },
            xy(axy){
                xy = axy;
                return api;
            },
            xy(axy){
                xy = axy;
                return api;
            },
            placed(){
                eventRouter.routeMessage({
                    type: "MovePlaced",
                    gameId: gameId,
                    move: {
                        side: side,
                        xy: xy
                    }
                });
                return api;
            }
        };
        return api;

    }



    //Testing cell render
    it('should render without error', function () {
        expect(
            shallow(
                <TicCell />
            ).length
        ).toEqual(1);
    });

    //Testing setting state manually
    it('Move should be X on X move and O on O move', function () {
        const cellWrapperX = shallow(<TicCell move={'X'} />);
        const cellWrapperO = shallow(<TicCell move={'O'} />);

        expect(
            cellWrapperX.unrendered.props.move
        ).toEqual('X');

        expect(
            cellWrapperO.unrendered.props.move
        ).toEqual('O');
    });

    it('Should have rigth side in cell ', function () {
        given().gameId("thegame").side("X").xy({x:1, y:2}).placed();
        expect(component.text()).toBe("X");
    });

    it('Should have no side in cell on another cell ', function () {
        given().gameId("thegame").side("O").xy({x:2, y:0}).placed();
        expect(component.text()).toBe("");
    });

});
