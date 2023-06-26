//
//  CoustomTabBarController.swift
//  Karaoke List App
//
//  Created by 村上匡志 on 2023-03-07.
//

import UIKit

class CoustomTabBarController: UITabBarController {
  
  let color = Color()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    UITabBar.appearance().tintColor = UIColor.midori
    UITabBar.appearance().unselectedItemTintColor = UIColor.white
    
    if let tabItems = tabBarController?.tabBar.items {
      for item in tabItems {
        item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 50)!], for: .normal)
      }
    }

    
    let prominentTabBar = self.tabBar as! TabBar
    prominentTabBar.prominentButtonCallback = prominentTabTaped
    
    
  }
  
  func prominentTabTaped() {
    selectedIndex = (tabBar.items?.count ?? 0)/2
  }
}
