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
    /*manager  = SocketManager(socketURL:  URL(string:"myurl:123")!,
        config: [.log(true), .forceNew(true), .reconnectAttempts(10), .reconnectWait(6000), .connectParams(["key":"value"]), .forceWebsockets(true), .compress])
    */
    @State var manager: SocketManager!
        //= SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .compress, .forceWebsockets(false), .connectParams(["mb_id":"mania"])])

    @State var socket: SocketIOClient!
    
    @State var messages: [Dictionary<String, String>] = []
    @State var msg = "반갑습니다. "
    @State var output = ""
    
    
    
    var body: some View {
        VStack {
            HStack {
                Text("from: \(from)")
                Text("to: \(to)")
            }
            HStack {
                TextField("Message", text: $msg)
                Button(action: sendMessage) {
                    Text("Send")
                }
            }.padding()
            Text(self.output)
            
            List(messages, id:\.self)  { message in
                if message["from"] == self.from {
                    HStack{
                        Spacer()
                        Text(message["message"]!)
                    }
                } else {
                    HStack{
                        Text(message["message"]!)
                        Spacer()
                    }
                }
            }
            Spacer()
        }.onAppear(perform: socketConnection)
    }
    
    
    func sendMessage() {
        let myMsg = ["message": self.msg, "to": self.to, "from": self.from]
        //self.messages.append(myMsg)
        
        print("send: \(self.msg)")
        socket.emit("private:send", myMsg)
    }
    
    func socketConnection () {
        //let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress, .forceWebsockets(false), .connectParams(["mb_id":"mania"])])
        manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress, .forceWebsockets(false), .forcePolling(false), .connectParams(["mb_id": self.from]) ])
        //socket = manager.defaultSocket    // default namespace '/'
        socket = manager.socket(forNamespace: "/moal") // specil namespace '/consumer'

        //guard let socket = socket else { return }
        
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
            let greet = json[0]["message"].stringValue
            
        }
        
        socket.on("private:send") { data, ack in
            print("----- private:send --------")
            let json = JSON(data)[0]
            print(json)
            var message = [
                "message": json["message"].stringValue,
                "to": json["to"].stringValue,
                "from": json["from"].stringValue
            ]
            self.output = "\(json)"
            self.messages.append(message)
            
            
            
        }
        
        socket.on("check") {data, ack in
            print("--------- greet ---------")
            print(data)
            let json = JSON(data)
            //print(json)
            print(json[0])
            
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
