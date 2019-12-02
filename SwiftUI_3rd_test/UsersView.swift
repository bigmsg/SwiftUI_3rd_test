//
//  UsersView.swift
//  SwiftUI_3rd_test
//
//  Created by 양팀장(iMac) on 2019/12/02.
//  Copyright © 2019 양팀장(iMac). All rights reserved.
//

import SwiftUI

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

            }

        }.onAppear() {
            let index = self.users.firstIndex(of: self.mb_id)
            print("index: \(index!)")
            self.users.remove(at: 0)
            print(self.users)
        }
    }
}

/*struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}*/
