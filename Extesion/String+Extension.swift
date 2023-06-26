//
//  String+Extension.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-18.
//

import Foundation

extension String {
  func normalized() -> String {
    let fullwidthToHalfwidth = self.transformFullwidthToHalfwidth()
    let trimmed = fullwidthToHalfwidth.trimmingCharacters(in: .whitespaces)
    return trimmed.lowercased()
  }
  
  func transformFullwidthToHalfwidth() -> String {
    let halfwidthString = self.applyingTransform(.fullwidthToHalfwidth, reverse: false)
    return halfwidthString ?? self
  }
}
