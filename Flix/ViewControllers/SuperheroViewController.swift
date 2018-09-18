//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Joseph Andy Feidje on 9/18/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Super Hero"
        collectionView.dataSource = self
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
            print("------------->",movie)
            if let posterPathString = movie["poster_path"] as? String {
                print("posterrrr-------------->> ",posterPathString)
            let baseUrlString = "https://image.tmdb.org/t/p/w500"
            let posterURLString = URL(string: baseUrlString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURLString)
        }
        return cell
    }
    
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=f09a904547a3537c895babf5612886fa")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // retrieving data
            if let error = error {
                print(error.localizedDescription)
//                self.networkErrorAlert()
            }
            else if let data = data {
                let dataDictionnary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionnary["results"] as! [[String: Any]]
                self.movies = movies
                self.collectionView.reloadData()
//                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
}
