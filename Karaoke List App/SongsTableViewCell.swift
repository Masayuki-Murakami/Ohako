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
  @IBOutlet var detailImage: UIImageView!
  @IBOutlet var labelBg: UIView!
  
  
  @IBOutlet var favoriteButtonTrailingToLabelBg: NSLayoutConstraint!
  @IBOutlet var favoriteButtonTrailingToDetailImage: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
