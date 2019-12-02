//
//  ChatView.swift
//  SwiftUI_3rd_test
//
//  Created by 양팀장(iMac) on 2019/12/02.
//  Copyright © 2019 양팀장(iMac). All rights reserved.
//

import SwiftUI
import SocketIO
import SwiftyJSON

struct ChatView: View {
    var to: String
    var from: String
    
    let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .compress, .forceWebsockets(false),])
    @State var socket: SocketIOClient!
    
    @State var messages: [Dictionary<String, String>] = []
    @State var msg = ""
    
    
    
    var body: some View {
        VStack {
            HStack {
                Text("from: \(from)")
                Text("to: \(to)")
            }
            HStack {
                TextField("Message", text: $msg)
                Button(action: {
                    let mymsg = ["message": self.msg, "to": self.to, "from": self.from]
                    self.messages.append(mymsg)
                }) {
                    Text("Send")
                }
            }.padding()
            List(messages, id:\.self)  { message in
                Text(message["message"]!)
            }
            Spacer()
        }.onAppear(perform: socketConnection)
    }
    
    func socketConnection () {
        //let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress, .forceWebsockets(false), .forcePolling(false)])
        socket = manager.defaultSocket    // default namespace '/'
        //socket = manager.socket(forNamespace: "/consumer") // specil naamespace '/consumer'

        guard let socket = socket else { return }
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            print("data: \(data)")
            print("ack: \(ack)")
            
            let json = JSON(data)
            //print(json)
            print(json[0])
            //print(type(of:json[0]["greet"]))
            let greet = json[0]["greet"].stringValue

//            socket.emit("myroom", ["greet": "Hi Python"])
//            socket.emit("update", ["amount": "update emitted"])
        }
        socket.on("connection") {data, ack in
            print("--------- connection ---------")
            let json = JSON(data)
            //print(json)
            print(json[0])
            //print(type(of:json[0]["greet"]))
            let greet = json[0]["greet"].stringValue
            
        }
        
        //socket.emit("myroom", ["greet": "hello"])

        socket.on("myroom") {data, ack in
            print("------------ receving myroom ------------")
            print("\(data)")
            //print("\(data[0]["greet"] as! String)")
            
            let json = JSON(data)
            //print(json)
            print(json[0])
            //print(type(of:json[0]["greet"]))
            let greet = json[0]["greet"].stringValue
 
            //self!.dataLabel.text = "\(data[0])"
            
            //guard let cur = data[0] as? Double else { return }
            let cur = 25
            
            /*socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                socket.emit("update", ["amount": cur + 2.50])
            }

            ack.with("Got your currentAmount", "dude")
            */
        }
        
        /*socket.on("myroom") {[weak self] data, ack in
            print("\n------- myroom: receving -----------\n")
            print("myroom event.on: \(data)")
            self!.dataLabel.text = "\(data["greet"])"
        }*/
        
        socket.on(clientEvent: .disconnect) {data, ack in
            print("--- disconnected ------")
            print("\(data)")
        }

        socket.connect()
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(to: "mania", from: "bigmsg")
    }
}
