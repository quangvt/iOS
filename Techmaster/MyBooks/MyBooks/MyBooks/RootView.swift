//
//  RootView.swift
//  MyBooks
//
//  Created by CanDang on 1/5/16.
//  Copyright © 2016 CanDang. All rights reserved.
//

import UIKit

class RootView: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        delegateType!.valueDidChange("PDF")
    }
    
    
}
