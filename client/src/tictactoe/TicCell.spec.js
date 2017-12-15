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


    it('should render without error', function () {
        expect(
            shallow(
                <TicCell />
            ).length
        ).toEqual(1);
    });

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

    it('MoveEvent from side should put that side in cell', function () {

    });

});
