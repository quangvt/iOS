//
//  MapViewController.swift
//  iTour
//
//  Created by Quang Vu on 5/23/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBAction func actionShowPlay(_ sender: UIButton) {
        performSegue(withIdentifier: "showPlay", sender: sender)
//        performSegue(withIdentifier: "showPlay", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let titleButton = (sender as? UIButton)?.currentTitle
        
        switch segue.identifier ?? "" {
        case "showPlay":
            print("show play \(titleButton!)")
        default:
            print("default play")
        }
    }
}
