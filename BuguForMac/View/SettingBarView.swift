//
//  SettingBarView.swift
//  BuguForMac
//
//  Created by 林少龙 on 2020/4/20.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct SettingBarView: View {
    @Binding var showLibrary: Bool

    var body: some View {
        HStack{
            Button(action: {self.showLibrary.toggle()}) {
            Text("Manage Sound")
            }
            Spacer()
        }
        .background(Color("ControllBarBackGroundColor"))
    }
}

struct SettingBarView_Previews: PreviewProvider {
    static var previews: some View {
        SettingBarView(showLibrary: .constant(false))
    }
}
