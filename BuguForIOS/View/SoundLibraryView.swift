//
//  SoundLibrary.swift
//  Bugu
//
//  Created by 林少龙 on 2020/3/30.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct SoundLibraryView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.editMode) var editMode
    @State var isShowFavorite = true

    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Rectangle()
                    .frame(width: 40, height: 6)
                    .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    .cornerRadius(10)
                HStack {
                    Spacer()
                    EditButton()
                    .foregroundColor(Color("ButtonColor"))
                }
                .padding(.horizontal)
                HStack {
                    Text(isShowFavorite ? "Favorite" :"Library")
                        .font(.largeTitle)
                    Spacer()
                    Button(action: {self.isShowFavorite.toggle()}) {
                        Text(isShowFavorite ? "Library" : "Favorite")
                    }
                    .foregroundColor(Color("ButtonColor"))
                }
                .padding(.horizontal)
                
                List {
                    ForEach(userData.subSounds){ item in
                        if item.isFavorite || !self.isShowFavorite {
                            AudioRowView(isShowFavorite: self.isShowFavorite, audioInfo: item)
                        }
                    }
                    .onDelete { (indexSet) in
                        self.userData.subSounds[indexSet.first!].isFavorite = false
                    }
                    .onMove { (from, to) in
                        self.userData.subSounds.move(fromOffsets: from, toOffset: to)
                    }
                }
            }
            .padding(.top)
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
    var isShowFavorite: Bool

    var audioInfo: AudioInfo
    
    var body: some View {
        Button(action: {
            if !self.isShowFavorite {
                self.userdata.subSounds[self.audioInfo.id].isFavorite.toggle()
            }
        }) {
                HStack {
                    Image(audioInfo.name)
                    Text(audioInfo.name)
                    Spacer()
                    Image(systemName: audioInfo.isFavorite ? "star.fill" : "star")
                    .foregroundColor(Color("ButtonColor"))
                }
        }
    }
}
