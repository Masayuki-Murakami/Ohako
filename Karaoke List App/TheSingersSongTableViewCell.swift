//
//  theSingersSongTableViewCell.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-15.
//

import UIKit

class TheSingersSongTableViewCell: UITableViewCell {
  
  @IBOutlet var songNameLabel: UILabel!
  @IBOutlet var singerNameLabel: UILabel!
  @IBOutlet var scoreLabel: UILabel!
  @IBOutlet var machineLabel: UILabel!
  @IBOutlet var separaterView: UIView!
  @IBOutlet var favoriteButton: UIButton!
  @IBOutlet var labelBg: UIView!
  
  @IBOutlet var favoriteButtonTrailingToLabelBg: NSLayoutConstraint!
  @IBOutlet var favoriteButtonTrailingToDetailImage: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }

}
