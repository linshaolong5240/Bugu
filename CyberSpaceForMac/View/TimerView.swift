//
//  TimerView.swift
//  CyberSpaceForMac
//
//  Created by 林少龙 on 2020/4/20.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var player: Player
    @ObservedObject var viewModel: TimerViewModel

    @State var hours: Int = 0
    @State var minutes: Int = 15
    
    init(_ viewModel: TimerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Button(action: {
                if self.viewModel.timerFlag {
                    self.viewModel.stopTimer()
                }else {
                    self.viewModel.setTimer(hours: TimeInterval(self.hours), minutes: TimeInterval(self.minutes), action: {self.player.stopAllChannel()})
                }
            }) {
                HStack {
                    Spacer()
                    Text(viewModel.timerFlag ? "Pause" : "Start")
                        .padding()
                    Spacer()
                }
                .background(viewModel.timerFlag ? Color("DangerColor") : Color("ActiveColor"))
            }
            .buttonStyle(PlainButtonStyle())
            if viewModel.timerFlag {
                HStack {
                    FlipView(viewModel.filpViewModels[0])
                    FlipView(viewModel.filpViewModels[1])

                    FlipView(viewModel.filpViewModels[2])
                    FlipView(viewModel.filpViewModels[3])

                    FlipView(viewModel.filpViewModels[4])
                    FlipView(viewModel.filpViewModels[5])
                }
            }else {
                VStack {
                    Picker(selection: $hours,
                           label: Text("hours").frame(width: 50)) {
                        Text("00").tag(0)
                        Text("01").tag(1)
                        Text("02").tag(2)
                        Text("03").tag(3)
                        Text("04").tag(4)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                    Picker(selection: $minutes,
                           label: Text("minutes").frame(width: 50)) {
                        Text("15").tag(15)
                        Text("20").tag(20)
                        Text("25").tag(25)
                        Text("30").tag(30)
                        Text("45").tag(45)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(TimerViewModel())
        .environmentObject(Player())
    }
}
