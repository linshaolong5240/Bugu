//
//  HomeView.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/3/30.
//  Copyright © 2020 teeloong. All rights reserved.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var player: Player
    @State var showTimer: Bool = false
    @State var showMainSoundView: Bool = true
    @State var showSubSoundsView: Bool = true

    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            VStack {
                MainSoundView(showMainSoundView: $showMainSoundView, showMyAudioView: $showSubSoundsView)
                SubSoundsView(showMainSoundView: $showMainSoundView, showSubSoundView: $showSubSoundsView)
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)

            VStack {
                Spacer()
                BottomBarView(showTimer: $showTimer)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct MySoundView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone Xʀ")
        .environmentObject(UserData())
        .environmentObject(Player())
//        .environment(\.colorScheme, .dark)
    }
}
