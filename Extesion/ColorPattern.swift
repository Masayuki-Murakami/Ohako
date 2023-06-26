//
//  ColorPattern.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-01-30.
//

import Foundation
import UIKit

struct Color {
  let sumiIro = UIColor(hex: "#303030", alpha: 1.0)
  let aiiro = UIColor(hex: "#203448", alpha: 1.0)
  let green = UIColor(hex: "#1EC689", alpha: 1.0)
}

extension UIColor {
  convenience init(hex: String, alpha: CGFloat = 1.0) {
    let v = Int("000000" + hex, radix: 16) ?? 0
    let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
    let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
    let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
    self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
  }
}

extension UIColor {
  class var midori: UIColor {
    return UIColor(named: "midori")!
  }
}
