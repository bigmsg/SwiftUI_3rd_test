//
//  MainViewController.swift
//  SwiftUI_3rd_test
//
//  Created by 관리자 on 2019/11/30.
//  Copyright © 2019 양팀장(iMac). All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

class MainViewController: UIViewController {

    let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .compress, .forceWebsockets(false)])
    var socket: SocketIOClient!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataLabel.text = "...."

        
        print("------ connect() ... -------")
        //self.data = "good"

        //let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress, .forceWebsockets(false)])
        socket = manager.defaultSocket

        guard let socket = socket else { return }
        
        DispatchQueue.main.async {
            //self.dataLabel.text = "socketio connected"
        }
        
        socket.on(clientEvent: .connect) {[weak self] data, ack in
            print("socket connected")
            print("data: \(data)")
            print("ack: \(ack)")
            DispatchQueue.main.async {
                //self!.dataLabel.text = "socketio connectedeee"
            }
            socket.emit("myroom", ["greet": "Hi Python"])
            socket.emit("update", ["amount": "update emitted"])
        }
        
        //socket.emit("myroom", ["greet": "hello"])

        socket.on("myroom") {[weak self] data, ack in
            print("------------ receving myroom ------------")
            print("\(data)")
            //print("\(data[0]["greet"] as! String)")
            
            let json = JSON(data)
            //print(json)
            print(json[0])
            //print(type(of:json[0]["greet"]))
            let greet = json[0]["greet"].stringValue
            print("type: \(type(of: greet))")
            self?.dataLabel.text = greet
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
        
        socket.on(clientEvent: .disconnect) {[weak self] data, ack in
            print("--- disconnected ------")
            print("\(data)")
            let json = JSON(data)
            //print(json)
            print(json[0])
            //print(type(of:json[0]["greet"]))
            let greet = json[0]["greet"].stringValue
            self?.dataLabel.text = greet
        }

        socket.connect()
        
    }
    

}
