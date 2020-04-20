//
//  Player.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/3/21.
//  Copyright © 2020 teeloong. All rights reserved.
//

import AVFoundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import MediaPlayer

let SOUND_FILE_TYPE = "m4a"

enum PlayState {
    case play
    case pause
    case stop
}
class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer! = nil
    var soundInfo: AudioInfo? = nil
    var soundMeta: SoundMetaData? = nil
    @Published var isPlaying: Bool = false
    @Published var volume: Float = 0 {
        didSet {
            audioPlayer.volume = volume
            soundInfo!.volume = volume
        }
    }
    init(_ soundMeta: SoundMetaData) {
        self.soundMeta = soundMeta
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundMeta.filePath))
//            audioPlayer.volume = 0.5
            audioPlayer.numberOfLoops = -1
            play()
        }
        catch {
            print("AVAudioPlayer init error")
        }
    }
    
    init(_ audioInfo: AudioInfo) {
        self.soundInfo = audioInfo
        if let path = Bundle.main.url(forResource: audioInfo.name, withExtension: SOUND_FILE_TYPE) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer.volume = audioInfo.volume
                self.volume = audioInfo.volume
                audioPlayer.numberOfLoops = -1
                play()
            }
            catch {
                print("AVAudioPlayer init error")
            }
        }else {
            print("can't find sound")
        }
    }
    func play() {
        audioPlayer.play()
        updateIsPlaying()
    }
    func pause() {
        audioPlayer.pause()
        updateIsPlaying()
    }
    func stop() {
        audioPlayer.stop()
        updateIsPlaying()
    }
    private func updateIsPlaying() {
        isPlaying = audioPlayer.isPlaying
    }
}

class Player: ObservableObject {
    var mainChannels = [UUID:AudioPlayer]()
    var subChannels = [Int:AudioPlayer]()
    @Published var isPlaying: Bool = false
    @Published var currentPlaying: String = ""
    private var interruptionObserver: NSObjectProtocol!
    private var shouldResume = false
    #if os(macOS)
    var mixMode: Bool = false {
        didSet {
            removeAllChannel()
        }
    }
    #else
    lazy var timerViewModel: TimerViewModel = TimerViewModel()
    #endif

    var currentMix: [AudioInfo]? {
        var  list = [AudioInfo]()
        if subChannels.count > 0 {
            for (_, channel) in subChannels {
                list.append(channel.soundInfo!)
            }
            return list
        }else {
            return nil
        }
    }
    init() {
        #if os(macOS)
        #else
        handleNowPlayableSessionStart()
        createRemoteControll()
        #endif
    }
    func playMixSound(_ mixSound: MixSound) {
        removeAllChannel()
        if let soundMeta =  mixSound.soundMeta {
            addMainChannel(soundMeta)
        }
        if let audioInfos =  mixSound.audioInfos{
            for audioInfo in audioInfos {
                addSubChannel(audioInfo)
            }
        }
        updateState()
    }
    func addSubChannel(_ audioInfo: AudioInfo) -> Void {
        subChannels[audioInfo.id] = AudioPlayer(audioInfo)
        updateState()
    }
   
//    func pause(_ name: String) -> Void {
//        audioChannel[name]?.pause()
//        audioChannel.removeValue(forKey: name)
//        updateIsPlaying()
//    }
    
    func removeSubChannel(_ audioInfo: AudioInfo) -> Void {
        subChannels[audioInfo.id] = nil
        updateState()
    }
    func removeAllChannel() -> Void {
        mainChannels.removeAll()
        subChannels.removeAll()
        updateState()
    }

    @objc func playAllChannel() -> Void {
        controllAllChannel(state: .play)
    }
    
    @objc func pauseAllChannel() {
        controllAllChannel(state: .pause)
    }
    
    func stopAllChannel() -> Void {
        controllAllChannel(state: .stop)
    }
    
    func toogleAllChannel() {
        if isPlaying {
            pauseAllChannel()
        }else {
            playAllChannel()
        }
    }
    
    func controllAllChannel(state : PlayState) {
        for (_, channel) in mainChannels {
            switch state {
            case .play:
                channel.play()
            case .pause:
                channel.pause()
            case .stop:
                channel.stop()
            }
        }
        for (_, channel) in subChannels {
            switch state {
            case .play:
                channel.play()
            case .pause:
                channel.pause()
            case .stop:
                channel.stop()
            }
        }

        updateState()
    }
    func updateState() {
        updateCurrentPlaying()
        updateIsPlaying()
        #if os(macOS)
        #else
        updateMPNowPlayingInfo()//end
        #endif
    }
    func updateCurrentPlaying(){
        currentPlaying = ""
//        let channels =  audioChannel.sorted { (i, j) -> Bool in
//            return j.value.soundInfo.id > i.value.soundInfo.id ? true : false
//        }
        for (_, channel) in mainChannels {
            currentPlaying += channel.soundMeta!.title! + " "
        }
        for (_, channel) in subChannels {
            currentPlaying += channel.soundInfo!.name + " "
        }
    }
    
    private func updateIsPlaying() {
        var count: Int = 0
        for (_, channel) in mainChannels {
            if channel.isPlaying {
                count += 1
            }
        }
        for (_, channel) in subChannels {
            if channel.isPlaying {
                count += 1
            }
        }
        if count > 0{
            isPlaying = true
        }else {
            isPlaying = false
        }
    }
}

extension Player {
    func addMainChannel(_ soundMeta: SoundMetaData) {
        mainChannels.removeAll()
        mainChannels[soundMeta.id] = AudioPlayer(soundMeta)
        updateState()
    }
    func removeMainChannel(soundMeta: SoundMetaData) {
        mainChannels[soundMeta.id] = nil
        updateState()
    }
//    func playMain(soundMeta: SoundMetaData) {
//        mainChannels[soundMeta.id]?.play()
//        updateState()
//    }
//    func stopMain(soundMeta: SoundMetaData) {
//        mainChannels[soundMeta.id]?.stop()
//        updateState()
//    }
//    func pauseMain(soundMeta: SoundMetaData) {
//        mainChannels[soundMeta.id]?.pause()
//        updateState()
//    }
}
#if os(macOS)
#else
extension Player {
    private func updateMPNowPlayingInfo() {
        var info = [String : Any]()
        info[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.audio.rawValue
        info[MPMediaItemPropertyTitle] = currentPlaying//歌名
        info[MPMediaItemPropertyArtist] = "Cyber Space"//mainChannels.first?.value.soundMeta?.artist//作者
        //         [info setObject:self.model.filename forKey:MPMediaItemPropertyAlbumTitle];//专辑名
        //         info[MPMediaItemPropertyAlbumArtist] = mainChannels.first?.value.soundMeta?.artist//专辑作者
        if let data = mainChannels.first?.value.soundMeta?.artwork {
            let image = UIImage(data: data)!
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (size) -> UIImage in
                return image
            })//显示的图片
        }
        
        //         info[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration//总时长
        //         info[MPNowPlayingInfoPropertyPlaybackRate] = 1.0//播放速率
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
    }
    private func createRemoteControll() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { (envent) -> MPRemoteCommandHandlerStatus in
            self.playAllChannel()
            return .success
        }
        commandCenter.pauseCommand.addTarget{ (envent) -> MPRemoteCommandHandlerStatus in
            self.pauseAllChannel()
            return .success
        }
    }
    func handleNowPlayableSessionStart() {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        // Observe interruptions to the audio session.
        
        interruptionObserver = NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification,
                                                                      object: audioSession,
                                                                      queue: .main) {
                                                                        [unowned self] notification in
                                                                        self.handleAudioSessionInterruption(notification: notification)
        }
        
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        }
        catch {
            print("handleNowPlayableSessionStart error")
        }
        // Make the audio session active.
    }
    
    func handleNowPlayableSessionEnd() {
        
        // Stop observing interruptions to the audio session.
        
        interruptionObserver = nil
        
        // Make the audio session inactive.
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to deactivate audio session, error: \(error)")
        }
    }
    private func handleAudioSessionInterruption(notification: Notification) {
        
        // Retrieve the interruption type from the notification.
        
        guard let userInfo = notification.userInfo,
            let interruptionTypeUInt = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeUInt) else { return }
        
        // Begin or end an interruption.
        switch interruptionType {
            
        case .began:
            
            // When an interruption begins, just invoke the handler.
            
            //            interruptionHandler(.began)
            if isPlaying {
                pauseAllChannel()
                shouldResume = true
                do {
                    try AVAudioSession.sharedInstance().setActive(false)
                } catch {
                    print("Failed to deactivate audio session, error: \(error)")
                }
            }
            
        case .ended:
            // When an interruption ends, determine whether playback should resume
            // automatically, and reactivate the audio session if necessary.
            do {
                
                try AVAudioSession.sharedInstance().setActive(true)
                
                if let optionsUInt = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt,
                    AVAudioSession.InterruptionOptions(rawValue: optionsUInt).contains(.shouldResume) {
                    if shouldResume {
                        playAllChannel()
                        shouldResume = false
                    }
                }

                //                                interruptionHandler(.ended(shouldResume))
            }
                
                // When the audio session cannot be resumed after an interruption,
                // invoke the handler with error information.
                
            catch {
                print("Failed to reactivate audio session, error: \(error)")
                //                interruptionHandler(.failed(error))
            }

        @unknown default:
            break
        }
    }
}#endif
