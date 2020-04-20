//
//  HomeView.swift
//  CyberSpaceForMac
//
//  Created by 林少龙 on 2020/4/19.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            VStack(spacing: 0.0) {
                //必须有个正常style的button popover 的 transient 行为才会正常
                Button(action: {}) {
                    Text("")
                }
                .frame(width: 272, height: 0)
                
                ControllBarView()
                
                Picker("", selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                    Text("Alone").tag(1)
                    Text("Mix").tag(2)
                }
                .padding([.top, .bottom, .trailing], 7)
                .pickerStyle(SegmentedPickerStyle())
                Divider()
                GridView(data: userData.subSounds.filter{$0.isFavorite == true}, columns: 3, hSpacing: 1, vSpacing:  1) {
                    audioInfo in
                    SoundCardView(audioInfo)
                }
                .background(Color.primary.colorInvert())
            }
            SettingBarView()
        }
        .frame(width: 272, height: 600)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        .environmentObject(UserData())
        .environmentObject(Player())
    }
}
