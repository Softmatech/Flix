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
    var movies: [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        //https://api.themoviedb.org/3/movie/550?api_key=f09a904547a3537c895babf5612886fa
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=f09a904547a3537c895babf5612886fa")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // retrieving data
            if let error = error {
                print(error.localizedDescription)
            }
            else if let data = data {
               let dataDictionnary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionnary)
                
                let movies = dataDictionnary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPathString = movie["poster_path"] as! String
        let baseUrlString = "https://image.tmdb.org/t/p/w500"
        let posterUrl = URL(string: baseUrlString + posterPathString)!
        
        cell.posterImageView.af_setImage(withURL: posterUrl)
        cell.titleLabel.text = title
        cell.overviewlabel.text = overview
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
