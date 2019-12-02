//
//  UsersView.swift
//  SwiftUI_3rd_test
//
//  Created by 양팀장(iMac) on 2019/12/02.
//  Copyright © 2019 양팀장(iMac). All rights reserved.
//

import SwiftUI
func changeLoginView() {
    let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first!
    window.rootViewController = UIHostingController(rootView: LoginView())
    window.makeKeyAndVisible()
}

struct UsersView: View {
    var mb_id: String
    @State var users = ["mania", "bigmsg", "gt", "mama5208", "hickman"]
    
    init(mb_id: String) {
        self.mb_id = mb_id
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.self) { user in
                    
                    NavigationLink(destination: ChatView(to: user, from: self.mb_id)) {
                        Text(user)
                    }
                }

            }.navigationBarItems(trailing: Button(action: {
                    changeLoginView()
                }){
                    Text("Logout")
                }
            )

        }.onAppear() {
            let index = self.users.firstIndex(of: self.mb_id)
            print("index: \(index!)")
            self.users.remove(at: index!)
            print(self.users)
        }
    }
}

/*struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}*/
