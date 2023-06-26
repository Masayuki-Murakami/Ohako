//
//  SongsTableViewCell.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-02-23.
//

import UIKit

class SongsTableViewCell: UITableViewCell {
  
  @IBOutlet var songLable: UILabel!
  @IBOutlet var singerLabel: UILabel!
  @IBOutlet var scoreLabel: UILabel!
  @IBOutlet var machineLabel: UILabel!
  @IBOutlet var separeterView: UIView!
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
    
    // Configure the view for the selected state
  }

}
