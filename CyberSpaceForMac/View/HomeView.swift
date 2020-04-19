//
//  HomeView.swift
//  CyberSpaceForMac
//
//  Created by 林少龙 on 2020/4/19.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack {
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image("PlayIcon")
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image("TimerIcon").colorInvert()
                }
                .buttonStyle(PlainButtonStyle())
            }
            GridView(data: userData.subSounds.filter{$0.isFavorite == true}, columns: 3) {
                audioInfo in
                SoundCardView(audioInfo)
                .background(Color.gray)
//                    .padding(.horizontal, 10)
//                    .padding(.top, 10)
            }
        }
        .frame(maxWidth: 270, maxHeight: 600)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        .environmentObject(UserData())
    }
}
