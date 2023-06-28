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
    
    songsTableView.isHidden = count < 0
    tutorialLebel.isHidden = count > 0
    
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "songsCell", for: indexPath) as! SongsTableViewCell
    
    let totalRows = tableView.numberOfRows(inSection: indexPath.section)
    if totalRows == 1 {
      cell.separeterView.isHidden = true
    } else if indexPath.row == 0 {
      cell.separeterView.isHidden = false
    } else if indexPath.row == totalRows - 1 {
      cell.separeterView.isHidden = true
    } else {
      cell.separeterView.isHidden = false
    }
    
    let song = SongData.shared.filteredSongs()[indexPath.row]
    
    cell.singerLabel?.text = song.singer
    cell.songLable?.text = song.songName
    
    if song.score != "" {
      cell.labelBg.isHidden = false
      cell.favoriteButtonTrailingToLabelBg.isActive = true
      cell.favoriteButtonTrailingToDetailImage.isActive = false
      cell.scoreLabel?.text = song.score
      
      if song.machine == 0 {
        cell.machineLabel?.text = "DAM"
      } else {
        cell.machineLabel?.text = "JOY SOUND"
      }
      
    } else {
      cell.labelBg.isHidden = true
      cell.favoriteButtonTrailingToLabelBg.isActive = false
      cell.favoriteButtonTrailingToDetailImage.isActive = true
    }
    
    if song.favorite {
      cell.favoriteButton.isHidden = false
    } else {
      cell.favoriteButton.isHidden = true
    }

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let customCell = cell as? SongsTableViewCell else {
      return
    }
    
    let corners: UIRectCorner
    let totalRows = tableView.numberOfRows(inSection: indexPath.section)
    if totalRows == 1 {
      corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    } else if indexPath.row == 0 {
      corners = [.topLeft, .topRight]
    } else if indexPath.row == totalRows - 1 {
      corners = [.bottomLeft, .bottomRight]
    } else {
      corners = []
    }
    
    let maskPath = UIBezierPath(roundedRect: customCell.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 10.0, height: 10.0))
    let shape = CAShapeLayer()
    shape.path = maskPath.cgPath
    customCell.layer.mask = shape
  }


  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
      
      let removedSong = SongData.shared.removeSong(at: indexPath.row)
      
      if SongData.shared.numberOfSongs(forSingerName: removedSong.singer) == 0 {
        SongData.shared.removeSingerIfNeeded(removedSong.singer)
      }
      
      tableView.deleteRows(at: [indexPath], with: .fade)
      
      // Reload the remaining rows in the section.
      let remainingIndexPaths = Array(0..<tableView.numberOfRows(inSection: indexPath.section)).map { IndexPath(row: $0, section: indexPath.section) }
      tableView.reloadRows(at: remainingIndexPaths, with: .none)
      
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
