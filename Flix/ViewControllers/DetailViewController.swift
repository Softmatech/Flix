//
//  DetailViewController.swift
//  Flix
//
//  Created by Joseph Andy Feidje on 9/18/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit

enum MoviesKeys {
    static let title = "title"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
    static let movie_id = "id"
}
class DetailViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var BackDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movies: [[String: Any]] = []
    var movie: [String:Any]?
    var movie_id: NSNumber = 0
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            titleLabel.text = movie[MoviesKeys.title] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            let backdropPathString = movie[MoviesKeys.backdropPath] as! String
            let posterPathString = movie[MoviesKeys.posterPath] as! String
            movie_id = (movie["id"] as? NSNumber)!
            let baseUrlString = "https://image.tmdb.org/t/p/w500"
            
            let backdropURL = URL(string: baseUrlString + backdropPathString)!
            BackDropImageView.af_setImage(withURL: backdropURL)
            
            let posterpathURL = URL(string: baseUrlString + posterPathString)!
            posterImageView.af_setImage(withURL: posterpathURL)
        }
        // Do any additional setup after loading the view.
        
        // The didTap: method will be defined in Step 3 below.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        // Optionally set the number of required taps, e.g., 2 for a double click
        tapGestureRecognizer.numberOfTapsRequired = 2
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        print("$$$$$$$$$$$$$$$$$$")
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
                let video = segue.destination as! videoViewController
                video.videoURL = uRL
                }
            }
        }
        task.resume()
    }

}
