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
  

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.contentView.layer.shadowColor = UIColor.black.cgColor
    self.contentView.layer.shadowOpacity = 0.5
    self.contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.contentView.layer.shadowRadius = 4
    self.contentView.layer.masksToBounds = false
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }

}
