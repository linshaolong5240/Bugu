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
    
    var body: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            HStack {
                Circle()
                    .frame(width: 25, height: 25)
                    .foregroundColor(player.isPlaying ? Color.clear :Color.gray)
                    .overlay(Image(player.isPlaying ? "PauseIcon" : "PlayIcon"))
                Text(player.isPlaying ? "Pause" : "Play")
                    .font(.headline)
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image("TimerIcon")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(player.isPlaying ? Color("SoundCarActiveColor") : Color("ControllBarBackGroundColor"))
    }
}

struct ControllBarView_Previews: PreviewProvider {
    static var previews: some View {
        ControllBarView()
        .environmentObject(Player())
    }
}
