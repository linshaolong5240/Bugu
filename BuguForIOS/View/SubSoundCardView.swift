//
//  SoundView.swift
//  Bugu
//
//  Created by 林少龙 on 2020/3/26.
//  Copyright © 2020 teeloong. All rights reserved.
//

import SwiftUI
import CoreHaptics
import AudioToolbox

// Check if the device supports haptics.
let supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics

let colors: [Color] = [.blue, .green, .orange, .pink, .purple, .red, .yellow]
//let colors: [Color] = [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)),Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)),Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)),Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)),Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)),Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)),Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))]

struct SubSoundCardView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var player: Player
    var frameHeight: CGFloat = 120

    let audioInfo: AudioInfo
    
    init(audioInfo: AudioInfo) {
        self.audioInfo = audioInfo
    }

    //Gesture
    enum DragState {
        case inactive
        case pressing
        case dragging
        
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }

    @GestureState var gestureState = DragState.inactive
    
    var tapGesture: some Gesture {
        TapGesture()
            .onEnded(tapOnEnded)
    }
    
    var longPressDragGesture: some Gesture {
        SequenceGesture(LongPressGesture(minimumDuration: 1).onEnded(LongPressedOnEnded),
                        DragGesture().onChanged(updateVloume))
            .updating($gestureState) { value, state, transaction in
                switch value {
                case .first(true):
                    state = .pressing
                case .second(true, _):
                    state = .dragging
                default:
                    state = .inactive
                }
                transaction.animation = .default
        }
    }
    
    var tapOrlongPressDragGesture: some Gesture {
        ExclusiveGesture(tapGesture, longPressDragGesture)
    }

    var body: some View {
            ZStack {
                ZStack(alignment: .bottom) {
                    if player.subChannels[audioInfo.id]?.isPlaying ?? false {
                        Rectangle()
                            .frame(height: CGFloat(player.subChannels[audioInfo.id]!.volume) * frameHeight + 10)
                            .foregroundColor(colors[player.subChannels[audioInfo.id]!.soundInfo!.id % colors.count])
                    }
                    VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                }
                VStack {
                    if gestureState.isDragging {
                        Image(systemName: player.subChannels[audioInfo.id]!.volume > 0.6 ? "speaker.3.fill" : (player.subChannels[audioInfo.id]!.volume  > 0.3 ? "speaker.2.fill" : (player.subChannels[audioInfo.id]!.volume > 0 ? "speaker.1.fill" : "speaker.fill")))
                    }else {
                        Image(audioInfo.name)
                    }
                    Text(audioInfo.name)
                        .lineLimit(1)
                        .foregroundColor(Color.primary)
                }
            }
            .frame(height: frameHeight)
            .mask(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .gesture(tapOrlongPressDragGesture)
            .scaleEffect(gestureState.isDragging ? 1.1 : (gestureState.isActive ? 0.9 : 1.0))
    }

    func tapOnEnded() {
        if player.isPlaying {
            if player.subChannels[audioInfo.id] != nil {
                player.removeSubChannel(audioInfo)
            }else {
                player.addSubChannel(audioInfo)
            }
        }else {
            if player.mainChannels.count != 0 || player.subChannels.count != 0 {
                player.removeAllChannel()
            }
            player.addSubChannel(audioInfo)
        }
    }
    
    func LongPressedOnEnded(value: Bool) {
        if player.isPlaying {
            if player.subChannels[audioInfo.id] == nil {
                player.addSubChannel(audioInfo)
            }
        }else {
            if player.subChannels.count != 0 {
                player.removeAllChannel()
            }
            player.addSubChannel(audioInfo)
        }
        AudioServicesPlaySystemSound(1520)
    }
    func updateVloume(value: DragGesture.Value) {
        let tanslation = (value.predictedEndLocation.y - value.location.y)
//        let step = Int(tanslation) % 5
//        if step == 0 {
//            AudioServicesPlaySystemSound(1519)
//        }
        let delta = Float(tanslation) / 2000
        if var volume = player.subChannels[audioInfo.id]?.volume {
            volume = delta > 0 ? max(0, volume - abs(delta)) : min(1, volume + abs(delta))
            player.subChannels[audioInfo.id]!.volume = volume
            userData.subSounds[audioInfo.id].volume = volume
        }
    }
}

struct SpeakerView: View {
    @Binding var volume: Float
    var body: some View {
        Image(systemName: volume > 0.6 ? "speaker.3.fill" : (volume > 0.6 ? "speaker.2.fill" : "speaker.fill"))
    }
}

struct SubSoundCardView_Previews: PreviewProvider {
    static var previews: some View {
//        MyAudioChannelView()
        SoundLibraryView()
        .environmentObject(UserData())
        .environmentObject(Player())
    }
}
