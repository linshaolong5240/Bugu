//
//  SoundLibraryView.swift
//  BuguForMac
//
//  Created by 林少龙 on 2020/4/20.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct SoundLibraryView: View {
    @EnvironmentObject var userData: UserData
    @State var isShowFavorite = false

    var body: some View {
        VStack {
            HStack {
                Text(isShowFavorite ? "Favorite" :"Library")
                    .font(.largeTitle)
                Spacer()
                Button(action: {self.isShowFavorite.toggle()}) {
                    Text(isShowFavorite ? "Library" : "Favorite")
                }
            }
            .padding(.horizontal)
            
            List {
                ForEach(userData.subSounds){ item in
                    if item.isFavorite || !self.isShowFavorite {
                        AudioRowView(isShowFavorite: self.isShowFavorite, audioInfo: item)
                    }
                }
            }
        }
    }
}

struct SoundLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        SoundLibraryView()
        .environmentObject(UserData())
        .environmentObject(Player())
    }
}

struct AudioRowView: View {
    @EnvironmentObject var userdata: UserData
    @EnvironmentObject var player: Player

    var isShowFavorite: Bool

    var audioInfo: AudioInfo
    
    var body: some View {
        Button(action: {
            if !self.isShowFavorite {
                self.userdata.subSounds[self.audioInfo.id].isFavorite.toggle()
                self.player.subChannels.removeValue(forKey: self.audioInfo.id)
            }
        }) {
            HStack {
                Image(audioInfo.name)
                Text(audioInfo.name)
                Spacer()
                if audioInfo.isFavorite {
                    Image("StarIcon")
                }
            }
            .background(Color("SoundCardBackGroundColor"))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
