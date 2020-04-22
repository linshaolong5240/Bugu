//
//  PlayDetailView.swift
//  Bugu
//
//  Created by 林少龙 on 2020/4/3.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct PlayListView: View {
    @EnvironmentObject var player: Player
    @EnvironmentObject var userData: UserData

    @Binding var showPlayDetail: Bool
    @State var showSaveMix: Bool = false

    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Rectangle()
                    .frame(width: 40, height: 6)
                    .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    .cornerRadius(10)
                if player.mainChannels.first != nil || player.subChannels.count > 0{
                    Text("current playing")
                        .padding()
                }

                if player.mainChannels.first != nil{
                    Text(player.mainChannels.first!.value.soundMeta!.title!)
                    .padding()
                }
                if player.subChannels.count > 0 {
                    Text("\(player.subChannels.count) Audio")
                    .padding()
                }
                if player.mainChannels.first != nil || player.subChannels.count > 0{
                    Button(action: {self.showSaveMix.toggle()}) {
                        HStack {
                            Image(systemName: "arrow.down.doc")
                            Text("Save This Mix Sound")
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.all, 10)
                    .background(Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
                    .clipShape(Capsule())
                    .sheet(isPresented: $showSaveMix) {
                        SaveMixView(showSaveMix: self.$showSaveMix)
                        .environmentObject(self.userData)
                        .environmentObject(self.player)
                    }
                }
                
                HStack {
                    Text("Play List")
                        .font(.largeTitle)
                    Spacer()
                    EditButton()
                        .foregroundColor(Color("ButtonColor"))
                }
                .padding()
                
                List {
                    ForEach(userData.playList) { mixSound in
                        PlayListRowView(mixSound: mixSound)
                    }
                    .onDelete { indexSet in
                        self.userData.playList.remove(at: indexSet.first!)
                    }
                    .onMove { indecies, newOffset in
                        self.userData.playList.move(fromOffsets: indecies, toOffset: newOffset)
                    }
                }
            }
            .padding(.top)
        }
    }
}

struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayListView(showPlayDetail: .constant(true))
        .previewDevice("iPhone Xʀ")
                .environmentObject(UserData())
                .environmentObject(Player())
        //        .environment(\.colorScheme, .dark)
    }
}

struct PlayListRowView: View {
    @EnvironmentObject var player: Player

    var mixSound: MixSound
    var body: some View {
        Button(action: {self.player.playMixSound(self.mixSound)}) {
            HStack {
                VStack(alignment: .leading) {
                    Text(mixSound.name)
                        .font(.title)
                        .lineLimit(1)
                    HStack {
                        if mixSound.soundMeta != nil {
                            Text(mixSound.soundMeta!.title!)
                                .fontWeight(.light)
                        }
                        if mixSound.audioInfos != nil {
                            ForEach(mixSound.audioInfos!) { sound in
                                Text(sound.name)
                                    .fontWeight(.light)
                            }
                        }
                    }
                    .lineLimit(1)
                }
                Spacer()
                Image(systemName: "play.fill")
            }
        }
    }
}
