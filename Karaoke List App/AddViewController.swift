//
//  AddViewController.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-14.
//

import UIKit

class AddViewController: UIViewController {
  
  @IBOutlet var addView: UIView!
  
  @IBOutlet var songNameTextField: UITextField!
  @IBOutlet var singerNameTextField: UITextField!
  @IBOutlet var keyTextField: UITextField!
  @IBOutlet var keyStepper: UIStepper!
  @IBOutlet var machineSegmentControl: UISegmentedControl!
  @IBOutlet var scoreTextField: UITextField!
  @IBOutlet var behindView: UIView!
  @IBOutlet var addButton: UIBarButtonItem!
  
  var segmentIndex = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    
    singerNameTextField.delegate = self
    songNameTextField.delegate = self
    scoreTextField.keyboardType = .decimalPad
    scoreTextField.delegate = self
    
    design()
    placeHolderAttributes()
    keyStepperValue()
    
//    updateMachineValue()
    
    keyTextField.isEnabled = false
    
  }
  
  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    guard let song = songNameTextField.text, !song.isEmpty else {
      songNameTextField.setBorderColor(.systemRed, alpha: 0.7)
      showAlert1(message: "曲名を入力してください")
      return
    }
    
    guard let singer = singerNameTextField.text, !singer.isEmpty else {
      singerNameTextField.setBorderColor(.systemRed, alpha: 0.7)
      showAlert1(message: "歌手名を入力してください")
      return
    }
    
    let score = scoreTextField.text
    let machineIndex = score != nil ? machineSegmentControl.selectedSegmentIndex : nil
    
    if let score = score {
      if !isScoreValid(score) {
        showInvalidInputAlert()
        scoreTextField.setBorderColor(.red, alpha: 0.7)
        return
      }
    }
    
//    let newSinger = Singer(singerName: singer)
    let newSong = Song(singer: singer, songName: song, score: score, machine: machineIndex, favorite: false)
    
//    SongData.shared.addSinger(newSinger)
    SongData.shared.addSong(newSong)
    dismiss(animated: true, completion: nil)
    
    songNameTextField.text = ""
    singerNameTextField.text = ""
    scoreTextField.text = ""
    keyTextField.text = ""
    machineSegmentControl.selectedSegmentIndex = 0
    scoreTextField.setBorderColor(.clear, alpha: 1.0)
    
    showAlert2(message: "")
  }
  
  
  
  func placeHolderAttributes() {
    let placeholderAttributes: [NSAttributedString.Key: Any] = [ .foregroundColor: UIColor.white.withAlphaComponent(0.5) ]
    
    songNameTextField.attributedPlaceholder = NSAttributedString(string: "曲名(必須)", attributes: placeholderAttributes)
    singerNameTextField.attributedPlaceholder = NSAttributedString(string: "歌手名(必須)", attributes: placeholderAttributes)
    keyTextField.attributedPlaceholder = NSAttributedString(string: "キー", attributes: placeholderAttributes)
    scoreTextField.attributedPlaceholder = NSAttributedString(string: "点数", attributes: placeholderAttributes)
  }
  
  func keyStepperValue() {
    keyStepper.minimumValue = -12
    keyStepper.maximumValue = 12
    keyStepper.value = 0
    keyStepper.stepValue = 1
  }
  
  @IBAction func keyStepperValueChanged(_ sender: UIStepper) {
    let value = Int(sender.value)
    let sign = value > 0 ? "+" : ""
    keyTextField.text = "\(sign)\(value)"
  }
  
  func isScoreValid(_ score: String) -> Bool {
    // nilの場合から文字をデフォルトにする
    let score = scoreTextField.text ?? ""
    
    // ユーザーが入力しなければから文字を返す
    if score.isEmpty {
      return true // Return true if the score is empty, which means the user hasn't entered any value
    }
    
    let scorePattern = "^(100|0*(\\d{1,2}(\\.\\d)?))$"
    let scoreRegex = try! NSRegularExpression(pattern: scorePattern, options: [])
    let scoreMatches = scoreRegex.matches(in: score, options: [], range: NSRange(location: 0, length: score.utf16.count))
    
    return !scoreMatches.isEmpty
  }

  
  @IBAction func machineSegmentControlchanged(_ sender: UISegmentedControl) {
    
    switch sender.selectedSegmentIndex {
    case 0:
      segmentIndex = 0
    case 1:
      segmentIndex = 1
    default:
      break
    }
  }
  
  
  // MARK: - Alert
  
  func showAlert1(message: String) {
    let alertController = UIAlertController(title: "入力を確認してください", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func showAlert2(message: String) {
    let alertController = UIAlertController(title: "曲が追加されました", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func showInvalidInputAlert() {
    let alertController = UIAlertController(title: "点数は100から小数点第一位まで入力できます", message: "例：100~100.0", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - Design
  func design() {
    songNameTextField.addShadow(color: .black, offset: CGSize(width: 3, height: 3), radius: 3, opacity: 0.7)
    singerNameTextField.addShadow(color: .black, offset: CGSize(width: 3, height: 3), radius: 3, opacity: 0.7)
    keyTextField.addShadow(color: .black, offset: CGSize(width: 3, height: 3), radius: 3, opacity: 0.7)
    scoreTextField.addShadow(color: .black, offset: CGSize(width: 3, height: 3), radius: 3, opacity: 0.7)
    keyStepper.layer.cornerRadius = 5
    keyStepper.applyViewShadow(color: .black, offset: CGSize(width: 3, height: 3), opacity: 0.7, radius: 3)
    behindView.layer.cornerRadius = 10
    behindView.applyViewShadow(color: .black, offset: CGSize(width: 3, height: 3), opacity: 0.7, radius: 3)
  }

  
}

// MARK: - Delegate

extension AddViewController: UITextFieldDelegate {
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    
    switch textField {
    case songNameTextField:
      if songNameTextField.text == "" {
        songNameTextField.setBorderColor(.red, alpha: 0.5)
      } else {
        songNameTextField.setBorderColor(.clear, alpha: 0.5)
      }
    case singerNameTextField:
      if singerNameTextField.text == "" {
        singerNameTextField.setBorderColor(.red, alpha: 0.5)
      } else {
        singerNameTextField.setBorderColor(.clear, alpha: 0.5)
      }
    case scoreTextField:
      let score = textField.text ?? ""
      if !isScoreValid(score) {
        // Handle invalid score format
      } else {
        // Handle valid score format
      }
    default:
      break
    }
  }
  
}

