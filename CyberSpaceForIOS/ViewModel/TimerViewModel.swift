//
//  TimerViewModel.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/4/17.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class TimerViewModel: ObservableObject {
    lazy var filpViewModels: [FlipViewModel] = (0...5).map({_ in FlipViewModel(fontSize: 40, cornerRadius: 4)})
    @Published var timerHours: TimeInterval = 0
    @Published var timerMinutes: TimeInterval = 0
    @Published var timerSeconds: TimeInterval = 0
    @Published var timerFlag = false

    var cancellAble = AnyCancellable({})
    private var timerAction: () -> Void = {}
    func setTimer(hours: TimeInterval, minutes: TimeInterval, action: @escaping () -> Void) {
        guard hours > 0 || minutes > 0 else {
            return
        }
        timerHours = hours
        timerMinutes = minutes
        timerSeconds = 0
        timerAction = action
        timerFlag = true
        cancellAble = Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink(receiveValue: {[weak self] (_) in
            self?.update()
        })
        self.filpViewModels = (0...5).map({_ in FlipViewModel(fontSize: 40, cornerRadius: 4)})
    }
    
    func stopTimer() {
        timerAction()
        cancellAble.cancel()
        timerFlag = false
        timerHours = 0
        timerMinutes = 0
        timerSeconds = 0
    }
    
    func update() {
        if timerSeconds > 0 {
            timerSeconds -= 1
        }else {
            if timerMinutes > 0 {
                timerMinutes -= 1
                timerSeconds = 59
            }else {
                if timerHours > 0 {
                    timerHours -= 1
                    timerMinutes = 59
                    timerSeconds = 59
                }else {
                    stopTimer()
//                    stopAllChannel()
                }
            }
        }
        let str = String(format: "%02d%02d%02d", Int(timerHours),Int(timerMinutes),Int(timerSeconds))
        setFlipViewModel(str)
    }
    func setFlipViewModel(_ time: String) {
        zip(time, filpViewModels).forEach { (char, viewModel) in
            viewModel.updateValue(String(char))
        }
    }
}
