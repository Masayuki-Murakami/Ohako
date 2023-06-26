//
//  Model.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-02-01.
//

import Foundation

class Song {
  
  var singer: String
  var songName: String
  var score: String?
  var key: String?
  var machine: Int?
  var favorite: Bool = false
  
  init(singer: String, songName: String, score: String? = nil, key: String? = nil, machine: Int? = nil, favorite: Bool = false) {
    self.singer = singer
    self.songName = songName
    self.score = score
    self.key = key
    self.machine = machine
    self.favorite = favorite
  }
  
  static func loadPost() -> [Song]? {
    return nil
  }
  
  static func sampleData() -> [Song] {
    
    return []
  }
  
}

struct Singer {
  var singerName: String
  
  init(singerName: String) {
    self.singerName = singerName
  }
  
  static func loadPost() -> [Singer]? {
    return nil
  }
  
  static func sampleData() -> [Singer] {
    let singer1 = Singer(singerName: "清水翔太")
    let singer2 = Singer(singerName: "One Ok Rock")
    let singer3 = Singer(singerName: "Ed Sheeran")
    
    return [singer1, singer2, singer3]
  }
  
}

//struct Machine {
//  var selectedMachineName: String?
//}


