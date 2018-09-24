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
    var key = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }

    override func viewWillAppear(_ animated: Bool) {
        if !key.isEmpty {
            let url = "https://www.youtube.com/watch?v=\(key)"
            print("+++++++++++++++++",url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
