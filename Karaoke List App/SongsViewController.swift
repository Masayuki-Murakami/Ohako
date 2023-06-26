//
//  SongsViewController.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-07.
//

import UIKit

class SongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var songsTableView: UITableView!
  @IBOutlet var tutorialLebel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    songsTableView.delegate = self
    songsTableView.dataSource = self
    
    songsTableView.layer.cornerRadius = 10
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if !tutorialLebel.isHidden {
      tutorialLebel.animateText(text: "下のみどりのボタンから曲を追加してね♪", characterDelay: 0.1) {}
    }
    
    songsTableView.reloadData()
  }
  
  @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    SongData.shared.isFilterringFavorite.toggle()
    songsTableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = SongData.shared.filteredSongs().count
    tutorialLebel.isHidden = count > 0
    
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "songsCell", for: indexPath) as! SongsTableViewCell
    
    let corners: UIRectCorner
    let totalRows = tableView.numberOfRows(inSection: indexPath.section)
    if totalRows == 1 {
      corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
      cell.separeterView.isHidden = true
    } else if indexPath.row == 0 {
      corners = [.topLeft, .topRight]
      cell.separeterView.isHidden = false
    } else if indexPath.row == totalRows - 1 {
      corners = [.bottomLeft, .bottomRight]
      cell.separeterView.isHidden = true
    } else {
      corners = []
      cell.separeterView.isHidden = false
    }
    
    let maskPath = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 10.0, height: 10.0))
    let shape = CAShapeLayer()
    shape.path = maskPath.cgPath
    cell.layer.mask = shape
    
    let song = SongData.shared.filteredSongs()[indexPath.row]
    
    cell.singerLabel?.text = song.singer
    cell.songLable?.text = song.songName
    
    if song.score != "" {
      cell.scoreLabel?.text = song.score
      
      if song.machine == 0 {
        cell.machineLabel?.text = "DAM"
      } else {
        cell.machineLabel?.text = "JOY SOUND"
      }
      
    } else {
      cell.scoreLabel?.text = ""
      cell.machineLabel?.text = ""
    }
    
    if song.favorite {
      cell.favoriteButton.isHidden = false
    } else {
      cell.favoriteButton.isHidden = true
    }

    return cell
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
      
      let removedSong = SongData.shared.removeSong(at: indexPath.row)
      
      if SongData.shared.numberOfSongs(forSingerName: removedSong.singer) == 0 {
        SongData.shared.removeSingerIfNeeded(removedSong.singer)
      }
      // Update the table view.
      tableView.deleteRows(at: [indexPath], with: .fade)
      completionHandler(true)
    }
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let favoriteAction = UIContextualAction(style: .normal, title: "お気に入り") { (action, view, completionHandler) in
      SongData.shared.songs[indexPath.row].favorite.toggle()
      
      tableView.reloadRows(at: [indexPath], with: .fade)
      completionHandler(true)
    }
    
    favoriteAction.backgroundColor = .midori
    
    let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "fromSongsTableView" {
      guard let detailViewController = segue.destination as? SongDetailViewController else { fatalError("Unexpected destination: \(segue.destination)") }
      
      guard let selectedIndexPath = songsTableView.indexPathForSelectedRow else { fatalError("No row selected") }
      
      detailViewController.song = SongData.shared.songs[selectedIndexPath.row]
    }
  }

    
}
