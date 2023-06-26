//
//  SongDetailViewController.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-18.
//

import UIKit

class SongDetailViewController: UIViewController {
  
  var song: Song?
  var isEditingEnabled = false
  
  var segumentIndex = 0
  
  @IBOutlet var songName: UITextField!
  @IBOutlet var singerName: UITextField!
  @IBOutlet var key: UITextField!
  @IBOutlet var keyStepper: UIStepper!
  @IBOutlet var machineSegmentControll: UISegmentedControl!
  @IBOutlet var scoreTextField: UITextField!
  @IBOutlet var behindView: UIView!
  @IBOutlet var editingButton: UIBarButtonItem!
  @IBOutlet var savingButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scoreTextField.keyboardType = .decimalPad
    
    self.title = song?.songName
    
    design()
    behindView.layer.cornerRadius = 10
    behindView.applyViewShadow(color: .black, offset: CGSize(width: 3, height: 3), opacity: 0.7, radius: 3)
    
    
    songName?.text = song?.songName
    singerName?.text = song?.singer
    key?.text = song?.key
    scoreTextField?.text = song?.score
    key?.text = song?.key
    if song?.machine == 0 {
      machineSegmentControll.selectedSegmentIndex = 0
    } else {
      machineSegmentControll.selectedSegmentIndex = 1
    }
    
    key.isEnabled = false
    savingButton.isHidden = true
    
    configureTextFieldsEditing()

  }
  
  
  
  fileprivate func editingButtonPressed() {
    editingButton.title = isEditingEnabled ? "キャンセル" : "編集"
    savingButton.isHidden = !isEditingEnabled
  }
  
  fileprivate func configureTextFieldsEditing() {
    songName.isEnabled = isEditingEnabled
    singerName.isEnabled = isEditingEnabled
    keyStepper.isEnabled = isEditingEnabled
//    machineSegmentControll.isEnabled = isEditingEnabled
    scoreTextField.isEnabled = isEditingEnabled
  }

  func isScoreValid(_ score: String) -> Bool {
    let score = scoreTextField.text ?? ""
    
    if score.isEmpty {
      return true
    }
    
    let scorePattern = "^(100|0*(\\d{1,2}(\\.\\d)?))$"
    let scoreRegex = try! NSRegularExpression(pattern: scorePattern, options: [])
    let scoreMatches = scoreRegex.matches(in: score, options: [], range: NSRange(location: 0, length: score.utf16.count))
    
    return !scoreMatches.isEmpty
  }
  
  @IBAction func EditingButtonTapped(_ sender: UIButton) {
    isEditingEnabled.toggle()
    editingButtonPressed()
    configureTextFieldsEditing()
    
    if !isEditingEnabled, let song = song {
      songName.text = song.songName
      singerName.text = song.singer
      key.text = song.key
      scoreTextField.text = song.score
      key.text = song.key
      machineSegmentControll.selectedSegmentIndex = song.machine == 0 ? 0 : 1
    }
  }
  
  @IBAction func savingButtonTapped(_ sender: UIButton) {
    if singerName.text != nil && songName.text != nil {
      let singerName = singerName.text, songName = songName.text, score = scoreTextField.text, key = key.text
      
      let machineIndex = score != nil ? machineSegmentControll.selectedSegmentIndex : nil
      
      if let score = score {
        if !isScoreValid(score) {
          showInvalidInputAlert()
          scoreTextField.setBorderColor(.red, alpha: 0.7)
          return
        }
      }
      
      let updatedSong = Song(singer: singerName!, songName: songName!, score: score, key: key, machine: machineIndex)
      
      if let oldSong = song {
        SongData.shared.editSong(oldSong: oldSong, newSong: updatedSong)
      } else {
        SongData.shared.addSong(updatedSong)
      }
      
      navigationController?.popViewController(animated: true)
    }
  }
  
  @IBAction func keyStepperTapped(_ sender: UIStepper) {
    let value = Int(sender.value)
    let sign = value > 0 ? "+" : ""
    key.text = "\(sign)\(value)"
  }
  
  func keyStepperValue() {
    keyStepper.minimumValue = -12
    keyStepper.maximumValue = 12
    keyStepper.value = 0
    keyStepper.stepValue = 1
  }
  
  func showInvalidInputAlert() {
    let alertController = UIAlertController(title: "点数は100から小数点第一位まで入力できます", message: "例：100~100.0", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func design() {
    songName.addShadow(color: .black, offset: CGSize(width: 3, height: 3), radius: 3, opacity: 0.7)
    singerName.addShadow(color: .black, offset: CGSize(width: 3, height: 3), radius: 3, opacity: 0.7)
    key.addShadow(color: .black, offset: CGSize(width: 3, height: 3), radius: 3, opacity: 0.7)
    scoreTextField.addShadow(color: .black, offset: CGSize(width: 3, height: 3), radius: 3, opacity: 0.7)
    keyStepper.layer.cornerRadius = 5
    keyStepper.applyViewShadow(color: .black, offset: CGSize(width: 3, height: 3), opacity: 0.7, radius: 3)
    behindView.layer.cornerRadius = 10
    behindView.applyViewShadow(color: .black, offset: CGSize(width: 3, height: 3), opacity: 0.7, radius: 3)
  }
  
}

