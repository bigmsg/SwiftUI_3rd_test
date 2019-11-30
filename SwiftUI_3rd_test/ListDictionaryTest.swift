//
//  ListDictionaryTest.swift
//  SwiftUI_3rd_test
//
//  Created by 양팀장(iMac) on 2019/11/27.
//  Copyright © 2019 양팀장(iMac). All rights reserved.
//

import SwiftUI
import SocketIO

struct ListDictionaryTest: View {
    var dictArray = [
        ["name": "Yang", "age": "46", "city":"paju"],
        ["name": "Kim", "age": "47", "city":"pusan"],
        ["name": "Jin", "age": "46", "city":"chunju"]
    ]
    @State var data = ""
    var body: some View {
        VStack {
            /*List (dictArray, id: \.self) { friend in
                Text("hello \(friend["name"]!)").onAppear(){
                    //print(friend)
                }
            }*/
            Spacer()
            Text("data: \(data)")
            Spacer()
        }.onAppear(){
            self.connect()
        }
        
    }
    
    
    func connect () {
        print("------ connect() ... -------")
        self.data = "good"

        let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            print("data: \(data)")
            print("ack: \(ack)")
            self.data = "hello"
            socket.emit("myroom", ["greet": "Hi Python"])
            socket.emit("update", ["amount": "update emitted"])
        }

        socket.on("myroom") {data, ack in
            guard let cur = data[0] as? Double else { return }
            self.data = "\(data)"
            
            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                socket.emit("update", ["amount": cur + 2.50])
            }

            ack.with("Got your currentAmount", "dude")
        }
        
        socket.on("myroom") {data, ack in
            print("\n------- myroom: receving -----------\n")
            print("myroom event.on: \(data)")
        }
        

        
        
        

        
        socket.on(clientEvent: .disconnect) {data, ack in
            print("--- disconnected ------")
            print("\(data)")
        }

        socket.connect()
    }
    
    
}

struct ListDictionaryTest_Previews: PreviewProvider {
    static var previews: some View {
        ListDictionaryTest()
    }
}
