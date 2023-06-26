//
//  SongTableViewCell.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-02-22.
//

import UIKit

class SongTableViewCell: UITableViewCell {
  
  @IBOutlet var songLabel: UILabel!
  @IBOutlet var singerLabel: UILabel!
  @IBOutlet var scoreLabel: UILabel!
  @IBOutlet var machineLabel: UILabel!
  

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
