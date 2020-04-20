//
//  ControllBarView.swift
//  CyberSpaceForMac
//
//  Created by 林少龙 on 2020/4/20.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct ControllBarView: View {
    //    @EnvironmentObject var userData: UserData
    @EnvironmentObject var player: Player
    
    @Binding var showTimer: Bool
    
    var body: some View {
        Button(action: {self.tooglePlay()}) {
            HStack {
                Circle()
                    .frame(width: 25, height: 25)
                    .foregroundColor(player.isPlaying ? Color.clear :Color.gray)
                    .overlay(Image(player.isPlaying ? "PauseIcon" : "PlayIcon"))
                Text(player.isPlaying ? "Pause" : "Play")
                    .font(.headline)
                Spacer()
                Button(action: {self.showTimer.toggle()}) {
                    Image("TimerIcon")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(player.isPlaying ? Color("SoundCarActiveColor") : Color("ControllBarBackGroundColor"))
    }
    func tooglePlay() {
        player.toogleAllChannel()
    }
}

struct ControllBarView_Previews: PreviewProvider {
    static var previews: some View {
        ControllBarView(showTimer: .constant(true))
        .environmentObject(Player())
    }
}
