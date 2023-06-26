//
//  singerTableViewCell.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-01-31.
//

import UIKit

class SingerTableViewCell: UITableViewCell {

  @IBOutlet var cellView: UIView!
  @IBOutlet var singerLabel: UILabel!
  @IBOutlet var songCountLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    cellView.layer.shadowColor = UIColor.black.cgColor
    cellView.layer.shadowOpacity = 0.2
    cellView.layer.shadowOffset = CGSize(width: 1, height: 1)
    cellView.layer.shadowRadius = 4
    cellView.layer.masksToBounds = false
    
    cellView.layer.cornerRadius = 10
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
