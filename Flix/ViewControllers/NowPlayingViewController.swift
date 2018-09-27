//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Joseph Andy Feidje on 9/17/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController,UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    var data = [String]()
    var searchController: UISearchController!
//    let image = UIImageView(frame: frame)
    
    let placeholderURL = URL(string: "Flix/Assets.xcassets/launch_image.imageset/launch_image.png")!
    let placeholderImages = UIImage(named: "placeholder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 50

        tableView.rowHeight = 150
        refreshControl = UIRefreshControl()
        searchController = UISearchController(searchResultsController: nil)
//        print("=================================",placeholderURL)
        self.title = "Movies"
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchMovies()
    }

        func networkErrorAlert(){
            let alertController = UIAlertController(title: "Network Error", message: "It's Seems there is a network error. Please try again later.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in self.fetchMovies()}))
            self.present(alertController, animated: true)
        }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }

    func fetchMovies() {
        activityIndicator.startAnimating()
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=f09a904547a3537c895babf5612886fa")!
        //https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key=<<api_key>>&language=en-US
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // retrieving data
            if let error = error {
                print(error.localizedDescription)
                self.networkErrorAlert()
            }
            else if let data = data {
                let dataDictionnary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let movies = dataDictionnary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
        activityIndicator.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
//        cell.posterImageView.af_setImage(withURL: placeholderURL,placeholderImage: placeholderImages)
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPathString = movie["poster_path"] as! String
        
//        let baseUrlString = "https://image.tmdb.org/t/p/w500"
        
        let smallImageRequest = URL(string: "https://image.tmdb.org/t/p/w45" + posterPathString)!
        let largeImageRequest = URL(string: "https://image.tmdb.org/t/p/original" + posterPathString)!

        cell.posterImageView.af_setImage(withURL: smallImageRequest,placeholderImage: placeholderImages,imageTransition: .crossDissolve(0.5))
        success: do {
            cell.posterImageView.af_setImage(withURL: smallImageRequest,placeholderImage: placeholderImages,imageTransition: .crossDissolve(0.5))
        }
        cell.posterImageView.af_setImage(withURL: largeImageRequest,placeholderImage: placeholderImages,imageTransition: .crossDissolve(0.5))
        success: do {
            cell.posterImageView.af_setImage(withURL: largeImageRequest,placeholderImage: placeholderImages,imageTransition: .crossDissolve(0.5))
        }

//        let posterUrl = URL(string: baseUrlString + posterPathString)!
        
        cell.titleLabel.text = title
        cell.overviewlabel.text = overview
        cell.selectionStyle = .gray
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightGray
        cell.selectedBackgroundView = backgroundView
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexpath = tableView.indexPath(for: cell) {
            let movie = movies[indexpath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
