//
//  ViewController.swift
//  TMDB my self
//
//  Created by Леонід Шевченко on 03.08.2021.
//

import UIKit
import Alamofire
import RealmSwift

class ViewController: UIViewController {
    
    var tvies: [TV] = []
    var movies: [Movie] = []
    
    
    
    let realm = try? Realm()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TVMovieSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TVTableViewCell")
        let tvTableViewCellIdentifier = String(describing: TVTableViewCell.self)
        self.tableView.register(UINib(nibName: tvTableViewCellIdentifier, bundle: nil),
                                 forCellReuseIdentifier: tvTableViewCellIdentifier)
        
        let movieTableViewCellIdentifier = String(describing: MovieTableViewCell.self)
        self.tableView.register(UINib(nibName: movieTableViewCellIdentifier, bundle: nil),
                                 forCellReuseIdentifier: movieTableViewCellIdentifier)
        
        
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        self.title = "TVs/Movies"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestTrendingTVies()
        self.requestTrendingMovies()
        
    }
    
    
    
    //MARK: - Network request for reloading TVs
    func requestTrendingTVies() {
        
        let url = "https://api.themoviedb.org/3/trending/tv/week?api_key=242869b42a65c82d7bfdc955a766ce9f"
        AF.request(url).responseJSON { responce in
            
            let decoder = JSONDecoder()
            
            if let data = try? decoder.decode(PopularTVResult.self, from: responce.data!){
                self.tvies = data.tvies ?? []
                self.tableView.reloadData()
            }
            
        }
    }
    
    //MARK: - Network request for reloading movies
    func requestTrendingMovies() {
        
        let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=242869b42a65c82d7bfdc955a766ce9f"
        AF.request(url).responseJSON { responce in
            
            let decoder = JSONDecoder()
            
            if let data = try? decoder.decode(PopularMovieResult.self, from: responce.data!){
                self.movies = data.movies ?? []
                self.tableView.reloadData()
            }
            
        }
    }
    
    
}

//MARK: - DataSource for tableView
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = self.TVMovieSegmentedControl.selectedSegmentIndex
        switch selectedIndex
        {
        case 0:
            return tvies.count
        case 1:
            return movies.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedIndex = self.TVMovieSegmentedControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            let tvCell = tableView.dequeueReusableCell(withIdentifier: "TVTableViewCell", for: indexPath) as! TVTableViewCell
            
            // UI for TVies
            let tvMedia = self.tvies[indexPath.row]
            let tvImagePathString = Constants.network.defaultImagePath + tvMedia.posterPath!
            tvCell.tvConfigureWith(imageURL: URL(string: tvImagePathString),
                                   TVName: tvMedia.name,
                                   desriptionText: tvMedia.overview)
            
            return tvCell
        case 1:
     
            let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell

            // UI for Movies
            let moviesMedia = self.movies[indexPath.row]
            let movieImagePathString = Constants.network.defaultImagePath + moviesMedia.poster_path!
            movieCell.movieConfigureWith(imageURL: URL(string: movieImagePathString),
                                          movieName: moviesMedia.name,
                                          desriptionText: moviesMedia.overview)
            return movieCell
        default:
            return UITableViewCell()
        }
        

        

        
        
    }
    
    @IBAction func TVMovieSegmentedChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
}
//MARK: - Delegate for tableView
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let selectedIndex = self.TVMovieSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            let TVidentifier = String(describing: TVDetailsViewController.self)
            
            if let detailViewController = storyboard.instantiateViewController(identifier: TVidentifier) as? TVDetailsViewController {
                detailViewController.tv = self.tvies[indexPath.row]
                
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        case 1:
            let movieidentifier = String(describing: MovieDetailsViewController.self)
            
            if let detailViewController = storyboard.instantiateViewController(identifier: movieidentifier) as? MovieDetailsViewController {
                detailViewController.movie = self.movies[indexPath.row]
                
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            
        default:
            let TVidentifier = String(describing: TVDetailsViewController.self)
            
            if let detailViewController = storyboard.instantiateViewController(identifier: TVidentifier) as? TVDetailsViewController {
                detailViewController.tv = self.tvies[indexPath.row]
                
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  460
    }
    //Appearing cells animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    
}

//!
