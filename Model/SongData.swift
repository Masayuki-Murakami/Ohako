//
//  SongData.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-18.
//

import Foundation

class SongData {
  static let shared = SongData()
  
  private let dataStore = DataStore()
  
  var isFilterringFavorite: Bool = false
  
  private init() {}
  
  public var songs: [Song] {
    get {
      return dataStore.loadSongs()
    }
    set {
      dataStore.saveSongs(songs: newValue)
    }
  }
  
  public var singers: [Singer] {
    get {
      return dataStore.loadSingers()
    }
    set {
      dataStore.saveSingers(singers: newValue)
    }
  }
  
  func addSong(_ song: Song) {
    var currentSongs = songs
    currentSongs.append(song)
    songs = currentSongs
    addSinger(Singer(singerName: song.singer))
    saveSongsToUserDefaults()
    saveSingersToUserDefaults()
  }
  
  func clearSongs() {
    songs = []
  }
  
  func editSong(oldSong: Song, newSong: Song) {
    var currentSongs = songs
    if let index = currentSongs.firstIndex(where: { $0.songName == oldSong.songName && $0.singer == oldSong.singer }) {
      currentSongs[index] = newSong
      songs = currentSongs
      if oldSong.singer != newSong.singer {
        removeSingerIfNeeded(oldSong.singer)
        addSinger(Singer(singerName: newSong.singer))
      }
    }
  }
  
  private func addSinger(_ singer: Singer) {
    var currentSingers = singers
    let normalizedSingerName = singer.singerName.normalized()
    let trimmedSingerName = normalizedSingerName.trimmingCharacters(in: .whitespaces)
    if !currentSingers.contains(where: { $0.singerName.normalized() == trimmedSingerName }) {
      let newSinger = Singer(singerName: trimmedSingerName)
      currentSingers.append(newSinger)
      singers = currentSingers
    }
  }
  
  func saveSongsToUserDefaults() {
    let encoder = JSONEncoder()
    if let encodedData = try? encoder.encode(songs) {
      UserDefaults.standard.set(encodedData, forKey: "songs")
    }
  }
  
  func saveSingersToUserDefaults() {
    let encoder = JSONEncoder()
    if let encodedData = try? encoder.encode(singers) {
      UserDefaults.standard.set(encodedData, forKey: "singers")
    }
  }
  
  func loadSongsFromUserDefaults() {
    if let savedData = UserDefaults.standard.data(forKey: "songs") {
      let decoder = JSONDecoder()
      if let loadedSongs = try? decoder.decode([Song].self, from: savedData) {
        songs = loadedSongs
      }
    }
  }
  
  func loadSingersFromUserDefaults() {
    if let savedData = UserDefaults.standard.data(forKey: "singers") {
      let decoder = JSONDecoder()
      if let loadedSingers = try? decoder.decode([Singer].self, from: savedData) {
        singers = loadedSingers
      }
    }
  }
  
  func removeSingerIfNeeded(_ singerName: String) {
    if !songs.contains(where: { $0.singer.normalized() == singerName.normalized() }) {
      var currentSingers = singers
      if let index = currentSingers.firstIndex(where: { $0.singerName.normalized() == singerName.normalized() }) {
        currentSingers.remove(at: index)
        singers = currentSingers
      }
    }
  }
  
  func numberOfSongs(forSingerName singerName: String) -> Int {
    let normalizedSingerName = singerName.normalized()
    return songs.filter { $0.singer.normalized() == normalizedSingerName }.count
  }
  
  func removeSong(at index: Int) -> Song {
    var currentSongs = songs
    let removedSong = currentSongs.remove(at: index)
    songs = currentSongs
    if numberOfSongs(forSingerName: removedSong.singer) == 0 {
      removeSingerIfNeeded(removedSong.singer)
    }
    return removedSong
  }
  
  func removeSong(withSinger singer: String, andSongName songName: String) -> Song? {
    var currentSongs = songs
    guard let index = currentSongs.firstIndex(where: { $0.singer == singer && $0.songName == songName }) else { return nil }
    let removedSong = currentSongs.remove(at: index)
    songs = currentSongs
    return removedSong
  }
  
  func toggleFavorite(forSongWithSinger singer: String, andSongName songName: String) {
    var currentSongs = songs
    if let index = currentSongs.firstIndex(where: { $0.singer == singer && $0.songName == songName }) {
      currentSongs[index].favorite.toggle()
      songs = currentSongs
    }
  }
  
  func filteredSongs() -> [Song] {
    if isFilterringFavorite {
      return songs.filter { $0.favorite }
    } else {
      return songs
    }
  }
  
}
