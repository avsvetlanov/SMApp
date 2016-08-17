//
//  ViewController.swift
//  SMApp
//
//  Created by  Svetlanov on 16.08.16.
//  Copyright © 2016  Svetlanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static let storyboardId = "NumberViewController"

    @IBOutlet weak var numberLabel: UILabel!
    
    var number : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nc = self.navigationController as? SlideMenuNavigationController {
            nc.addSlideMenuToViewController(self)
        }
        
        numberLabel.text = String(number)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

