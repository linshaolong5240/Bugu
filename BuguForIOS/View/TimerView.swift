//
//  TimerView.swift
//  Bugu
//
//  Created by 林少龙 on 2020/4/3.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var player: Player
    @ObservedObject var viewModel: TimerViewModel

    @State var hours: Int = 0
    @State var minutes: Int = 0

    init(_ viewModel: TimerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Rectangle()
                    .frame(width: 40, height: 6)
                    .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    .cornerRadius(10)
                Text("Timer")
                    .font(.largeTitle)
                Spacer()
                if viewModel.timerFlag {
                    HStack {
//                        ForEach(viewModel.filpViewModels) { item in
//                            FlipView(item)
//                        }
                        FlipView(viewModel.filpViewModels[0])
                        FlipView(viewModel.filpViewModels[1])
                        Text(":")
                            .font(.system(size: 40, weight: .heavy, design: .default))
                        FlipView(viewModel.filpViewModels[2])
                        FlipView(viewModel.filpViewModels[3])
                        Text(":")
                            .font(.system(size: 40, weight: .heavy, design: .default))
                        FlipView(viewModel.filpViewModels[4])
                        FlipView(viewModel.filpViewModels[5])
                    }
                }else {
                    HStack {
                        Spacer()
                        Picker(selection: $hours, label: Text("")) {
                            ForEach(0..<24) { i in
                                Text(String(i)).tag(i)
                            }
                        }
                        .frame(width: 200)
                        .clipped()
                        .overlay(Text("hours").offset(x: 50))
                        Spacer()
                        Picker("", selection: $minutes) {
                            ForEach(0..<60) { i in
                                Text(String(i)).tag(i)
                            }
                        }
                        .frame(width: 200)
                        .clipped()
                        .overlay(Text("minutes").offset(x: 50))
                        Spacer()
                    }
                    .padding()
                }
                Spacer()
                Button(action: {
                    if self.viewModel.timerFlag {
                        self.viewModel.stopTimer()
                    }else {
                        self.viewModel.setTimer(hours: TimeInterval(self.hours), minutes: TimeInterval(self.minutes), action: {self.player.stopAllChannel()})
                    }
                }) {
                    Text(viewModel.timerFlag ? "Stop" : "Start")
                        .frame(width: 200, height: 40)
                }
                .background(viewModel.timerFlag ? Color(#colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)) : Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
                .foregroundColor(.primary)
                .clipShape(Capsule())
                .padding()
            }
            .padding(.vertical)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(TimerViewModel())
        .environmentObject(Player())
    }
}
