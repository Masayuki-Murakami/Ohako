//
//  TextField+Extension.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-18.
//

import Foundation
import UIKit

extension UITextField {
  func setBorderColor(_ color: UIColor, alpha: CGFloat) {
    let colorAlpha = color.withAlphaComponent(alpha)
    self.layer.borderColor = colorAlpha.cgColor
    self.layer.borderWidth =  1.0
    self.layer.cornerRadius = 5
  }
  
  func applyShadow(color: UIColor, offset: CGSize) {
    let shadow = NSShadow()
    shadow.shadowColor = color
    shadow.shadowOffset = offset
    self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [ .foregroundColor: self.textColor!, .shadow: shadow ])
  }
  
  func addInnerShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float) {
    let innerShadowLayer = InnerShadowLayer()
    innerShadowLayer.frame = bounds
    innerShadowLayer.innerShadowColor = color
    innerShadowLayer.innerShadowOffset = offset
    innerShadowLayer.innerShadowRadius = radius
    innerShadowLayer.innerShadowOpacity = opacity
    layer.insertSublayer(innerShadowLayer, at: 0)
  }
  
  func addShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float) {
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOffset = offset
    self.layer.shadowRadius = radius
    self.layer.shadowOpacity = opacity
    self.layer.masksToBounds = false
  }
  
}

class InnerShadowLayer: CALayer {
  var innerShadowColor: UIColor = UIColor.black {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var innerShadowOffset: CGSize = CGSize(width: 2, height: 2) {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var innerShadowRadius: CGFloat = 3 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var innerShadowOpacity: Float = 0.5 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func draw(in ctx: CGContext) {
    ctx.setFillColor(backgroundColor ?? UIColor.white.cgColor)
    ctx.fill(bounds)
    
    let shadowRect = bounds.insetBy(dx: -bounds.width, dy: -bounds.height)
    let path = UIBezierPath(rect: bounds)
    let shadowPath = UIBezierPath(rect: shadowRect)
    
    path.append(shadowPath)
    path.usesEvenOddFillRule = true
    
    ctx.saveGState()
    ctx.addPath(path.cgPath)
    ctx.clip(using: .evenOdd)
    
    let opaqueShadowColor = innerShadowColor.withAlphaComponent(CGFloat(innerShadowOpacity))
    ctx.setShadow(offset: innerShadowOffset, blur: innerShadowRadius, color: opaqueShadowColor.cgColor)
    ctx.setBlendMode(.sourceOut)
    ctx.addPath(shadowPath.cgPath)
    ctx.fillPath()
    
    ctx.restoreGState()
  }
}

