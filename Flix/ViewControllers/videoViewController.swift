//
//  videoViewController.swift
//  Flix
//
//  Created by Joseph Andy Feidje on 9/24/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit

class videoViewController: UIViewController {

    @IBOutlet weak var videoViewController: UIWebView!
    var videoURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("------------------->>> ",videoURL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
