//
//  ContentView.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/3/21.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI
let screen = UIScreen.main.bounds
struct ContentView: View {
    @State var selection = 0

    init() {
//        UINavigationBar.appearance().backgroundColor = UIColor(named: "BackGroundColor")
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    var body: some View {
        ZStack {
            HomeView()
//            TabView(selection: $selection) {
//                MyAudioChannelView()
//                    .tabItem {
//                        Text("Favorite")
//                        Image(systemName: "star.fill")
//                }
//                .tag(0)
//                AudioChannelLibraryView()
//                    .tabItem {
//                        Text("All Sound")
//                        Image(systemName: "slider.horizontal.3")
//                }
//                .tag(1)
//                MyMixSoundView()
//                    .tabItem {
//                        Text("Settting")
//                        Image(systemName: "gear")
//                }
//                .tag(2)
//            }
//            NavigationView {
//                MyAudioChannelView()
//                    .navigationBarTitle("Favorite")
//                    .navigationBarItems(trailing: NavigationLink("All", destination: AudioChannelLibraryView()))
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .previewDevice("iPhone 11")
            .environmentObject(UserData())
            .environmentObject(Player())
//            .environment(\.colorScheme, .dark)
    }
}
