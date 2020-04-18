//
//  UserData.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/3/26.
//  Copyright © 2020 teeloong. All rights reserved.
//
import SwiftUI
import AVFoundation

//typealias MixSound = [SoundInfo]
struct SoundMetaData: Codable, Identifiable {
    var id = UUID()
    var albumname: String?
    var artist: String?
    var artwork: Data?
    var description: String?
    var title: String?
    var filePath: String
}
struct AudioInfo: Codable, Identifiable {
    var id: Int
    var name: String
    var isFavorite: Bool
    var volume: Float
}
struct MixSound: Codable,Identifiable{
    var id = UUID()
    var name: String
    var soundMeta: SoundMetaData?
    var audioInfos: [AudioInfo]?
}
struct JSONStruct: Codable {
    var id: Int
    var name: String
    var isFavorite: Bool
    var volume: Float
}

func updateJSON() {
    var jsonStruct = [JSONStruct]()
    
    let sounds: [AudioInfo] =  loadFileTOJSON("soundIndexes.json")

    for sound in sounds {
        jsonStruct.append(JSONStruct(id: sound.id - 1, name: sound.name, isFavorite: false, volume: 1))
    }
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
        let data = try encoder.encode(jsonStruct)
        print(String(data: data, encoding: .utf8)!)
    }
    catch {
        print("updateJSON error")
    }
}

struct UserDataKey {
   static let isFirstLaunch = "isFirstLaunch"
   static let everLaunch = "isFirstLaunch"
   static let mainSound = "mainSound"
   static let subSound = "subSound"
   static let playList = "playList"
}

final class UserData: ObservableObject  {
    var mainSounds = [SoundMetaData]()

    @Published var subSounds: [AudioInfo]
//    @Published var favoriteSounds: [SoundInfo]
//    @Published var unFavoriteSounds: [SoundInfo]
    @Published var playList: [MixSound]

    init() {
        if UserDefaults.standard.bool(forKey: UserDataKey.isFirstLaunch) {
            var data: Data
            //sub sound
            data = loadFileToData("soundIndexes.json")
            UserDefaults.standard.set(data, forKey: UserDataKey.subSound)
            //main sound
            mainSounds = getSoundMetaDatas()
            data = loadJSONToData(mainSounds)
            UserDefaults.standard.set(data, forKey: UserDataKey.mainSound)
            //playlist
            data = loadJSONToData([
                MixSound(name: "111", soundMeta: self.mainSounds[0], audioInfos: [AudioInfo(id: 0, name: "孤岛", isFavorite: true, volume: 1),AudioInfo(id: 1, name: "雨林", isFavorite: true, volume: 1)])
            ])
            UserDefaults.standard.set(data, forKey: UserDataKey.playList)
        }
        self.mainSounds = loadDataToJSON(UserDefaults.standard.data(forKey: UserDataKey.mainSound)!)
        self.subSounds = loadDataToJSON(UserDefaults.standard.data(forKey: UserDataKey.subSound)!)
        self.playList = loadDataToJSON(UserDefaults.standard.data(forKey: UserDataKey.playList)!)
//        self.favoriteSounds = sounds.filter{$0.isFavorite == true}
//        self.unFavoriteSounds = sounds.filter{$0.isFavorite == false}
    }
    func save(key: String) {
        var data: Data
        let encoder = JSONEncoder()

        switch key {
        case UserDataKey.mainSound:
            do {
                data = try encoder.encode(mainSounds)
                UserDefaults.standard.set(data, forKey: UserDataKey.mainSound)
            }catch {
                fatalError("save mainSound data error")
            }
        case UserDataKey.subSound:
            do {
                data = try encoder.encode(subSounds)
                UserDefaults.standard.set(data, forKey: UserDataKey.subSound)
            }catch {
                fatalError("save subSound data error")
            }
        case UserDataKey.playList:
            do {
                data = try encoder.encode(playList)
                UserDefaults.standard.set(data, forKey: UserDataKey.playList)
            }catch {
                fatalError("save playList data error")
            }
        default:
            break
        }
    }
}

func getSoundMetaDatas() -> [SoundMetaData] {
        let SOUND_DIR = "Sounds"

//        var soundPaths = [String]()
        let soundPaths = Bundle.main.paths(forResourcesOfType: SOUND_FILE_TYPE, inDirectory: SOUND_DIR)
        var sounds = [SoundMetaData]()
        for path in soundPaths {
            let avAssert = AVAsset(url: URL(fileURLWithPath: path))
            var soundMetaData = SoundMetaData(filePath: path)
            for i in  avAssert.availableMetadataFormats {
                for j in avAssert.metadata(forFormat: i) {
                    switch j.identifier {
                    case AVMetadataIdentifier.iTunesMetadataAlbum:
                        soundMetaData.albumname =  j.value as? String
                    case AVMetadataIdentifier.iTunesMetadataArtist:
                        soundMetaData.artist =  j.value as? String
                    case AVMetadataIdentifier.iTunesMetadataCoverArt:
                        if let data = (j.value as? Data) {
                            soundMetaData.artwork =  data//UIImage(data: data)
                        }
                    case AVMetadataIdentifier.iTunesMetadataUserComment:
                        soundMetaData.description = j.value as? String
                    case AVMetadataIdentifier.iTunesMetadataSongName:
                        soundMetaData.title =  j.value as? String
                    default:
                        break;
                    }
                    
                    //                    switch j.commonKey {
                    //                    case AVMetadataKey.commonKeyAlbumName:
                    //                        soundMetaData.albumname =  j.value as? String
                    //                    case AVMetadataKey.commonKeyArtist:
                    //                        soundMetaData.artist =  j.value as? String
                    //                    case AVMetadataKey.commonKeyArtwork:
                    //                        if let data = (j.value as? Data) {
                    //                            soundMetaData.artwork =  UIImage(data: data)
                    //                        }
                    //                    case AVMetadataKey.iTunesMetadataKeyUserComment:
                    //                        soundMetaData.description = j.value as? String
                    //                        print(soundMetaData.description ?? "error")
                    //                    case AVMetadataKey.commonKeyTitle:
                    //                        soundMetaData.title =  j.value as? String
                    //                    default:
                    //                        break;
                    //                    }
                }
            }
            sounds.append(soundMetaData)
        }
        return sounds
    }
