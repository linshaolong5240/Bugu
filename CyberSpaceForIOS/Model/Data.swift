//
//  Data.swift
//  Cyber Space
//
//  Created by 林少龙 on 2020/3/25.
//  Copyright © 2020 teeloong. All rights reserved.
//
import Foundation

func loadFileToData(_ filename: String) -> Data{
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
        return data
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
}
func loadDataToJSON<T: Decodable>(_ data: Data) -> T{
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse data as \(T.self):\n\(error)")
    }
}

func loadJSONToData<T: Encodable>(_ json: T) -> Data {
    do {
        let encoder = JSONEncoder()
        return try encoder.encode(json.self)
    } catch {
        fatalError("Couldn't parse data as \(T.self):\n\(error)")
    }
}

func loadFileTOJSON<T: Decodable>(_ filename: String) -> T {
    let data = loadFileToData(filename)

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
//func save<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//        else {
//            fatalError("Couldn't find \(filename) in main bundle.")
//    }
//
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}
