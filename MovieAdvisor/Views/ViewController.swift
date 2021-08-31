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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let selectedIndex = self.TVMovieSegmentedControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            cell.textLabel?.text = tvies[indexPath.row].name
            return cell
        case 1:
            cell.textLabel?.text = movies[indexPath.row].name
            return cell
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
    
    
}

//!
