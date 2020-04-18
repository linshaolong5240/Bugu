//
//  SaveMixView.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/4/13.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct SaveMixView: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var userData: UserData
    
    @Binding var showSaveMix: Bool

    @State var mixName = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20.0) {
                TextField("your mix name", text: $mixName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 40)
                Button(action: {
                    self.savePlayList()
                }) {
                    Text("Save")
                        .frame(width: 300, height: 35)
                }
                .background(Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
                .cornerRadius(5)            }
        }
    }
    
    func savePlayList() {
        userData.playList.append(MixSound(name: mixName, soundMeta: player.mainChannels.first?.value.soundMeta, audioInfos: player.currentMix))
        userData.save(key: UserDataKey.playList)
        showSaveMix.toggle()
    }
}

struct SaveMixView_Previews: PreviewProvider {
    static var previews: some View {
        SaveMixView(showSaveMix: .constant(true))
        .previewDevice("iPhone Xʀ")
                .environmentObject(UserData())
                .environmentObject(Player())
        //        .environment(\.colorScheme, .dark)
    }
}
