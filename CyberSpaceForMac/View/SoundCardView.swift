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
//    @EnvironmentObject var player: Player
    var frameHeight: CGFloat = 100
    let audioInfo: AudioInfo
    
    init(_ audioInfo: AudioInfo) {
        self.audioInfo = audioInfo
    }
    var body: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            Image(audioInfo.name)
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SoundCardView_Previews: PreviewProvider {
    static var previews: some View {
        SoundCardView(UserData().subSounds[0])
//        .environmentObject(UserData())
    }
}
