//
//  MainSoundView.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/4/10.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct MainSoundView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var player: Player
    @Binding var showMainSoundView: Bool
    @Binding var showMyAudioView: Bool
    var screen = UIScreen.main.bounds
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showMainSoundView.toggle()
                    if !self.showMainSoundView && !self.showMyAudioView {
                        self.showMyAudioView = true
                    }
                }) {
                    Text("Main Sounds")
                        .font(.title)
                    Spacer()
                    Image(systemName: showMainSoundView ? "arrowtriangle.down.fill" : "arrowtriangle.left.fill")
                }
                .frame(width: 180)
                .foregroundColor(Color("ButtonColor"))
                Spacer()
            }
            .padding(.horizontal, 10)

            if showMainSoundView {
                if !showMyAudioView {
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0.0) {
                        ForEach(userData.mainSounds) { item in
                            MainSoundCardView(soundMeta: item)
                        }
                  }
                }
                if !showMyAudioView {
                    Spacer()
                }
            }

        }
    }
}

struct MainSoundView_Previews: PreviewProvider {
    static var previews: some View {
        MainSoundView(showMainSoundView: .constant(true), showMyAudioView: .constant(true))
        .environmentObject(UserData())
        .environmentObject(Player())
    }
}
