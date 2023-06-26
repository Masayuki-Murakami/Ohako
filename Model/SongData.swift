//
//  SongData.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-18.
//

import Foundation

class SongData {
  static let shared = SongData()
  
  private(set) var songs: [Song] = []
  private(set) var singers: [Singer] = []
  
  var isFilterringFavorite: Bool = false
  
  private init() {}
  
  func addSong(_ song: Song) {
    songs.append(song)
    addSinger(Singer(singerName: song.singer))
  }
  
  func editSong(oldSong: Song, newSong: Song) {
    if let index = songs.firstIndex(where: { $0.songName == oldSong.songName && $0.singer == oldSong.singer }) {
      songs[index] = newSong
      if oldSong.singer != newSong.singer {
        removeSingerIfNeeded(oldSong.singer)
        addSinger(Singer(singerName: newSong.singer))
      }
    }
  }
  
  private func addSinger(_ singer: Singer) {
    let normalizedSingerName = singer.singerName.normalized()
    let trimmedSingerName = normalizedSingerName.trimmingCharacters(in: .whitespaces)
    
    if !singers.contains(where: { $0.singerName.normalized() == trimmedSingerName }) {
      let newSinger = Singer(singerName: trimmedSingerName)
      singers.append(newSinger)
    }
  }
  
  func removeSingerIfNeeded(_ singerName: String) {
    if !songs.contains(where: { $0.singer.normalized() == singerName.normalized() }) {
      if let index = singers.firstIndex(where: { $0.singerName.normalized() == singerName.normalized() }) {
        singers.remove(at: index)
      }
    }
  }
  
  func numberOfSongs(forSingerName singerName: String) -> Int {
    let normalizedSingerName = singerName.normalized()
    return songs.filter { $0.singer.normalized() == normalizedSingerName }.count
  }
  
  func removeSong(at index: Int) -> Song {
    let removedSong = songs.remove(at: index)
    
    if numberOfSongs(forSingerName: removedSong.singer) == 0 {
      removeSingerIfNeeded(removedSong.singer)
    }
    return removedSong
  }
  
  func removeSong(withSinger singer: String, andSongName songName: String) -> Song? {
    guard let index = songs.firstIndex(where: { $0.singer == singer && $0.songName == songName }) else { return nil }
    return removeSong(at: index)
  }
  
  func toggleFavorite(forSongWithSinger singer: String, andSongName songName: String) {
    if let index = songs.firstIndex(where: { $0.singer == singer && $0.songName == songName }) {
      
//      songs[index].favorite.toggle()
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

