//
//  SoundCardView.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/4/10.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct MainSoundCardView: View {
    @EnvironmentObject var player: Player

    var soundMeta: SoundMetaData
    var screen = UIScreen.main.bounds
    
    init(soundMeta: SoundMetaData) {
        self.soundMeta = soundMeta
    }
    var body: some View {
        VStack {
            Button(action: {self.tooglePlay()}) {
                Image(uiImage: UIImage(data: soundMeta.artwork!)!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
//                    .overlay(
//                        Image(systemName: (player.mainChannels[soundMeta.id]?.isPlaying ?? false  ? "pause.fill" : "play.fill"))
//                        .foregroundColor(Color("ButtonColor"))
//                )
                    .padding(.all, 10)
            }
            .frame(width: screen.width/3, height: screen.width/3)
            .rotationEffect(.degrees(player.mainChannels[soundMeta.id]?.isPlaying ?? false  ? 360 : 0))
            .animation(player.mainChannels[soundMeta.id]?.isPlaying ?? false  ? Animation.linear(duration: 6).repeatForever(autoreverses: false) : Animation.easeOut(duration: 1))
            
            //                    .grayscale(isPlaying ? 0 : 0.75)
            Text(soundMeta.title!)
                .frame(width: screen.width/3)
                .lineLimit(1)
        }
    }
    
    func tooglePlay() {
        if player.isPlaying {
            if player.mainChannels[soundMeta.id] != nil {
                player.removeMainChannel(soundMeta: soundMeta)
            }else {
                player.addMainChannel(soundMeta)
            }
        }else {
            if player.mainChannels.count != 0 || player.subChannels.count != 0 {
                player.removeAllChannel()
            }
            player.addMainChannel(soundMeta)
        }
    }
    
    func scaleByCenter(geometry: GeometryProxy) -> CGFloat{
        let delta = abs(geometry.frame(in: .global).midX - screen.midX)
        return 1 - (delta/screen.midX * 0.2)
    }
}

struct SoundCardView_Previews: PreviewProvider {
    static var previews: some View {
        MainSoundCardView(soundMeta: UserData().mainSounds[0])
        .environmentObject(Player())
    }
}
