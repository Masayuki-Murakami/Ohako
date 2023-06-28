//
//  TheSingersSongViewController.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-15.
//

import UIKit



class TheSingersSongViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var theSingersSongTableVeiw: UITableView!
  
  var selectedSinger: Singer?
  var filteredSongs: [Song] = []
  var song: Song?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    theSingersSongTableVeiw.delegate = self
    theSingersSongTableVeiw.dataSource = self
    navigationItem.title = selectedSinger?.singerName
    
    filterSongs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    filterSongs()
    
    theSingersSongTableVeiw.reloadData()
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredSongs.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SingersSongsCell", for: indexPath) as! TheSingersSongTableViewCell
    
    let totalRows = tableView.numberOfRows(inSection: indexPath.section)
    if totalRows == 1 {
      cell.separaterView.isHidden = true
    } else if indexPath.row == 0 {
      cell.separaterView.isHidden = false
    } else if indexPath.row == totalRows - 1 {
      cell.separaterView.isHidden = true
    } else {
      cell.separaterView.isHidden = false
    }
    
    let song = filteredSongs[indexPath.row]
    
    cell.singerNameLabel?.text = song.singer
    cell.songNameLabel?.text = song.songName
    
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
    guard let customCell = cell as? TheSingersSongTableViewCell else {
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
      
      let songToDelete = self.filteredSongs[indexPath.row]
      let removedSong = SongData.shared.removeSong(withSinger: songToDelete.singer, andSongName: songToDelete.songName)
      
      guard removedSong != nil else {
        completionHandler(false)
        return
      }
      
      if SongData.shared.numberOfSongs(forSingerName: songToDelete.singer) == 0 {
        SongData.shared.removeSingerIfNeeded(songToDelete.singer)
      }
      
      self.filteredSongs.remove(at: indexPath.row)
      
      tableView.deleteRows(at: [indexPath], with: .fade)
      
      let remainingIndexPaths = Array(0..<tableView.numberOfRows(inSection: indexPath.section)).map { IndexPath(row: $0, section: indexPath.section) }
      tableView.reloadRows(at: remainingIndexPaths, with: .none)
      
      completionHandler(true)
    }
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let favoriteAction = UIContextualAction(style: .normal, title: "お気に入り") { (action, view, completionHandler) in
      
      let songToToggle = self.filteredSongs[indexPath.row]
      SongData.shared.toggleFavorite(forSongWithSinger: songToToggle.singer, andSongName: songToToggle.songName)
      
      
      self.filteredSongs[indexPath.row].favorite.toggle()
      
      tableView.reloadRows(at: [indexPath], with: .fade)
      completionHandler(true)
    }
    
    favoriteAction.backgroundColor = .midori
    
    let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }
  
  func filterSongs() {
    if let singer = selectedSinger {
      let normalizedSingerName = singer.singerName.normalized()
      filteredSongs = SongData.shared.songs.filter {
        let normalizedSongSingerName = $0.singer.normalized()
        return normalizedSingerName == normalizedSongSingerName
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "fromTheSingersSong" {
      guard let detailViewController = segue.destination as? SongDetailViewController else { fatalError("Unexpected destination: \(segue.destination)") }
      
      guard let selectedIndexPath = theSingersSongTableVeiw.indexPathForSelectedRow else { fatalError("No row selected") }
      
      detailViewController.song = filteredSongs[selectedIndexPath.row]
    }
  }

}
