//
//  View+Extension.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-18.
//

import Foundation
import UIKit

extension UIView {
  func applyViewShadow(color: UIColor = .black, offset: CGSize = CGSize(width: 0, height: 2), opacity: Float = 0.5, radius: CGFloat = 2) {
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOffset = offset
    self.layer.shadowOpacity = opacity
    self.layer.shadowRadius = radius
  }
}
