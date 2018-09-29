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
//    var videoURL = "https://www.youtube.com/watch?v=vGLs0HCCVag"
    var movie_id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print("------------------->>> ",videoURL)

        
        var uRL = ""
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie_id)/videos?api_key=f09a904547a3537c895babf5612886fa&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let dataDictionnary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movie = dataDictionnary["results"] as! [[String: Any]]
                if movie != nil{
                    let mov = movie[0]
                    let key = mov["key"]as! String
                    uRL = "https://www.youtube.com/watch?v=\(key)"
                    print("************************-> ",uRL)
                            let url = URL(string: uRL)!
                            let urlRequest = URLRequest(url: url)
                    self.videoViewController.loadRequest(urlRequest)
                }
            }
        }
        task.resume()
        
        
    }
 
}
