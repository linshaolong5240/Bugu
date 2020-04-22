//
//  HomeView.swift
//  BuguForMac
//
//  Created by 林少龙 on 2020/4/19.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var player: Player

    @State var showTimer: Bool = false
    @State var showLibrary: Bool = false

    var body: some View {
        VStack(spacing: 0.0) {
            //必须有个正常style的button popover 的 transient 行为才会正常
            Button(action: {}) {
                Text("")
            }
            .frame(width: 272, height: 0)
            
            ControllBarView(showTimer: $showTimer)
            Divider()
            if showTimer {
                TimerView(player.timerViewModel)
            }
            ModePickerView()
            Divider()
            if showLibrary {
                SoundLibraryView()
            }else {
                GridView(data: userData.subSounds.filter{$0.isFavorite == true},
                         columns: 3,
                         showsIndicators: true,
                         hSpacing: 1,
                         vSpacing:  1) {
                            audioInfo in
                            SoundCardView(audioInfo)
                }
                .background(Color.primary.colorInvert())
            }
            Divider()
            SettingBarView(showLibrary: $showLibrary)
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
