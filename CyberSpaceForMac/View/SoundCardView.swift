//
//  SoundCardView.swift
//  CyberSpaceForMac
//
//  Created by 林少龙 on 2020/4/19.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct SoundCardView: View {
//    @EnvironmentObject var userData: UserData
    @EnvironmentObject var player: Player
    let audioInfo: AudioInfo
    
    init(_ audioInfo: AudioInfo) {
        self.audioInfo = audioInfo
    }
    
    var body: some View {
        Button(action: {self.togglePlay()}) {
            VStack {
                Image(audioInfo.name)
                Text(audioInfo.name)
            }
            .frame(width: 90, height: 100)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func togglePlay() {
        if player.isPlaying {
            if player.subChannels[audioInfo.id] != nil {
                player.removeSubChannel(audioInfo)
            }else {
                player.addSubChannel(audioInfo)
            }
        }else {
            if player.mainChannels.count != 0 || player.subChannels.count != 0 {
                player.removeAllChannel()
            }
            player.addSubChannel(audioInfo)
        }
    }
}

struct SoundCardView_Previews: PreviewProvider {
    static var previews: some View {
        SoundCardView(UserData().subSounds[0])
//        .environmentObject(UserData())
    }
}
