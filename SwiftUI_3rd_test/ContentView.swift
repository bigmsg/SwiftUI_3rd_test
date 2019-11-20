//
//  ContentView.swift
//  SwiftUI_3rd_test
//
//  Created by 양팀장(iMac) on 2019/11/20.
//  Copyright © 2019 양팀장(iMac). All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct JokesData : Identifiable{
    public var id: Int
    public var joke: String
}

class Observer : ObservableObject{
    @Published var jokes = [JokesData]()
    @Published var image:Image?

    init() {
        getJokes()
        getImage()
    }
    
    func getImage(count: Int = 5) {
        Alamofire.request("https://i.pravatar.cc/400?img=/\(count)", method: .get).response
            { response in
                print(response.data)
                
                
        }
    }
    
    
    func getJokes(count: Int = 5)
    {
        /*
            let parameters: [String: [String]]  = [
                "foo": ["bar"],
                "baz": ["a", "b"],
                "qux": ["x", "y", "z"]
            ]
         
            Alamofire.request("http", method: .post, parameters: parameters)
            Alamofire.upload()
            Alamofire.download()
        */
        Alamofire.request("http://api.icndb.com/jokes/random/\(count)").responseJSON
            { response in
                //print(response.result.value)
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    //print(json)
                    print(json["value"][0]["joke"])
                case .failure(let error):
                    print("Request Failed")
                }
                
        }
    }
}


struct ContentView: View {
    @ObservedObject var observed = Observer()
    
    var body: some View {
        NavigationView{
            List(observed.jokes){ i in
                HStack{Text(i.joke)}
                }.navigationBarItems(
                  trailing: Button(action: addJoke, label: { Text("Add") }))
            .navigationBarTitle("SwiftUI Alamofire")
        }
    }
    
    func addJoke(){
        observed.getJokes(count: 1)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
