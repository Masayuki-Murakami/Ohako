//
//  DataStore.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-06-30.
//

import Foundation

class DataStore {
  
  private let userDefaults = UserDefaults.standard
  private let songsKey = "songs"
  private let singersKey = "singers"
  
  func saveSongs(songs: [Song]) {
    if let encodedData = try? JSONEncoder().encode(songs) {
      userDefaults.set(encodedData, forKey: songsKey)
    }
  }
  
  func loadSongs() -> [Song] {
    guard let savedData = userDefaults.data(forKey: songsKey),
          let decodedData = try? JSONDecoder().decode([Song].self, from: savedData) else {
      return []
    }
    return decodedData
  }
  
  func saveSingers(singers: [Singer]) {
    if let encodedData = try? JSONEncoder().encode(singers) {
      userDefaults.set(encodedData, forKey: singersKey)
    }
  }
  
  func loadSingers() -> [Singer] {
    guard let savedData = userDefaults.data(forKey: singersKey),
          let decodedData = try? JSONDecoder().decode([Singer].self, from: savedData) else {
      return []
    }
    return decodedData
  }
}

