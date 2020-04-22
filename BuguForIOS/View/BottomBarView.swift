//
//  BottomBarView.swift
//  Bugu
//
//  Created by 林少龙 on 2020/4/10.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var userData: UserData
    @Binding var showTimer: Bool
    @State var showPlayDetail: Bool = false
    @State var showSaveMixSound: Bool = false

    @State var mixSoundName: String = ""
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            HStack(spacing: 20.0) {
                Button(action: {self.showTimer.toggle()}) {
                    Image(systemName: "timer")
                        .font(.system(size: 30))
                    .frame(width: 40, height: 40)
                }
                .foregroundColor(Color("ButtonColor"))
                .sheet(isPresented: $showTimer) {
                    TimerView(self.player.timerViewModel)
                    .environmentObject(self.userData)
                    .environmentObject(self.player)
                }
                
                Button(action: {self.showPlayDetail.toggle()}) {
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                        HStack {
                            if player.mainChannels.count > 0 || player.subChannels.count > 0 {
                                Button(action: {self.player.toogleAllChannel()}) {
                                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: 30))
                                        .frame(width: 40, height: 40)
                                }                            }
                            
                            Text(player.currentPlaying).lineLimit(1)
                            Spacer()
                            Image(systemName: "arrowtriangle.up.circle")
                            .foregroundColor(Color("ButtonColor"))
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .foregroundColor(.primary)
                .frame(height: 40)
                .cornerRadius(10)
                .sheet(isPresented: $showPlayDetail) {
                    PlayListView(showPlayDetail: self.$showPlayDetail)
                        .environmentObject(self.userData)
                        .environmentObject(self.player)
                }
            }
            .padding(.horizontal)
        }
        .frame( height: 80)
    }
}

struct SaveMixSoundView: View {
    @Binding var showSaveMixSound: Bool
    @Binding var mixSoundName: String
    var body: some View {
        VStack {
            Spacer()
            Text("Save Mix Sound")
                .font(.largeTitle)
            
            HStack {
                Text("name")
                TextField("Placeholder", text: self.$mixSoundName)
            }
            HStack {
                Button(action: {self.showSaveMixSound.toggle()}) {
                    Text("Cancel")
                }
                Button(action: {self.showSaveMixSound.toggle()}) {
                    Text("Done")
                }
            }
        }
    }
}


struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(showTimer: .constant(true))
        .environmentObject(UserData())
        .environmentObject(Player())
    }
}
