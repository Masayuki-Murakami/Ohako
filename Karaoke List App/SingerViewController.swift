//
//  ViewController.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-01-30.
//

import UIKit


class SingerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var singerTableView: UITableView!
  @IBOutlet var tutorialLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    singerTableView.dataSource = self
    singerTableView.delegate = self
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if !tutorialLabel.isHidden {
      tutorialLabel.animateText(text: "下のみどりのボタンから曲を追加してね♪", characterDelay: 0.1) {}
    }
    
    singerTableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = SongData.shared.singers.count
    
    tutorialLabel.isHidden = count > 0
    
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "singersCell", for: indexPath) as! SingerTableViewCell
    let singer = SongData.shared.singers[indexPath.row]
    
    cell.singerLabel?.text = singer.singerName
    let numOfSong = SongData.shared.numberOfSongs(forSingerName: singer.singerName)
    cell.songCountLabel?.text = "\(numOfSong)"
    
    cell.layer.cornerRadius = 10
    cell.selectionStyle = UITableViewCell.SelectionStyle.gray
    
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showSingersSongs",
       let destination = segue.destination as? TheSingersSongViewController,
       let indexPath = singerTableView.indexPathForSelectedRow {
      destination.selectedSinger = SongData.shared.singers[indexPath.row]
    }
  }
  
}

extension UILabel {
  func animateText(text: String, characterDelay: TimeInterval, completion: @escaping () -> Void) {
    let characters = Array(text)
    var index = 0
    Timer.scheduledTimer(withTimeInterval: characterDelay, repeats: true) { timer in
      if index < characters.count {
        let substring = String(characters[0...index])
        self.text = substring
        index += 1
      } else {
        timer.invalidate()
        completion()
      }
    }
  }

}

