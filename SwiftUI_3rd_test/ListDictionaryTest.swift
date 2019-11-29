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
    var body: some View {
        List (dictArray, id: \.self) { friend in
            Text("hello \(friend["name"]!)").onAppear(){
                print(friend)
            }
        }.onAppear(){
            self.connect()
        }
    }
    
    
    func connect () {
        print("------ connect() ... -------")

        let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        socket.on("currentAmount") {data, ack in
            guard let cur = data[0] as? Double else { return }
            
            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                socket.emit("update", ["amount": cur + 2.50])
            }

            ack.with("Got your currentAmount", "dude")
        }

        socket.connect()
    }
    
    
}

struct ListDictionaryTest_Previews: PreviewProvider {
    static var previews: some View {
        ListDictionaryTest()
    }
}
