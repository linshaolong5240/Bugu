//
//  SettingBarView.swift
//  CyberSpaceForMac
//
//  Created by 林少龙 on 2020/4/20.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct SettingBarView: View {
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer()
            Divider()
            HStack{
                Spacer()
                Text("setting")
            }.padding()
                .background(Color("ControllBarBackGroundColor"))
        }
    }
}

struct SettingBarView_Previews: PreviewProvider {
    static var previews: some View {
        SettingBarView()
    }
}
