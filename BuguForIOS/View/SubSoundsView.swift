//
//  MyAudioView.swift
//  Bugu
//
//  Created by 林少龙 on 2020/4/10.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct SubSoundsView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var player: Player
    @Binding var showMainSoundView: Bool
    @Binding var showSubSoundView: Bool
    @State var showSoundLibrary: Bool = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showSubSoundView.toggle()
                    if !self.showMainSoundView && !self.showSubSoundView {
                        self.showMainSoundView = true
                    }
                }) {
                    Text("Sub Sounds")
                        .font(.title)
                    Spacer()
                    Image(systemName: showSubSoundView ? "arrowtriangle.down.fill" : "arrowtriangle.left.fill")
                }
                .frame(width: 180)
                .foregroundColor(Color("ButtonColor"))

                Spacer()
                Button(action: {self.showSoundLibrary.toggle()}) {
                    Image(systemName: "tray.full.fill")
                    Text("Manage")
                }
                .foregroundColor(Color("ButtonColor"))
                .sheet(isPresented: $showSoundLibrary) {
                    SoundLibraryView()
                    .environmentObject(self.userData)
                    .environmentObject(self.player)
                }
            }
            .padding(.horizontal, 10)
            .foregroundColor(.primary)

            if showSubSoundView {
                GridView(data: userData.subSounds.filter{$0.isFavorite == true}, columns: 3) {
                    audioInfo in
                    SubSoundCardView(audioInfo: audioInfo)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                }
            }else {
                HStack {
                    Spacer()
                }
                .frame( height: 80)
            }
        }
    }
}

struct MyAudioView_Previews: PreviewProvider {
    static var previews: some View {
        SubSoundsView(showMainSoundView: .constant(true), showSubSoundView: .constant(true))
        .environmentObject(UserData())
        .environmentObject(Player())
    }
}
