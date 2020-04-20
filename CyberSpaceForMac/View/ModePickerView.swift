//
//  ModePickerView.swift
//  CyberSpaceForMac
//
//  Created by 林少龙 on 2020/4/20.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct ModePickerView: View {
    //    @EnvironmentObject var userData: UserData
    @EnvironmentObject var player: Player
    
    var body: some View {
        Picker("", selection: $player.mixMode) {
            Text("Alone").tag(false)
            Text("Mix").tag(true)
        }
        .padding([.top, .bottom, .trailing], 7)
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct ModePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ModePickerView()
//        .environmentObject(UserData())
        .environmentObject(Player())
    }
}
