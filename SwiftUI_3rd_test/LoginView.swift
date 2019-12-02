//
//  LoginView.swift
//  SwiftUI_3rd_test
//
//  Created by 양팀장(iMac) on 2019/12/02.
//  Copyright © 2019 양팀장(iMac). All rights reserved.
//

import SwiftUI
func changeUsersView(mb_id: String) {
    let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first!
    window.rootViewController = UIHostingController(rootView: UsersView(mb_id: mb_id))
    window.makeKeyAndVisible()
}



struct LoginView: View {
    @State var mb_id = "mania"
    var body: some View {
        NavigationView {
            VStack {
                TextField("id", text: $mb_id)
                Button(action: {
                    changeUsersView(mb_id: self.mb_id)
                }){
                    Text("로그인")
                }
            }.padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
