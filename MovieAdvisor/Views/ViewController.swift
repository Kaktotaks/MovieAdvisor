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
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")

        
        self.title = "Movies/TVs"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestTrendingTVies()
        self.requestTrendingMovies()
        
    }
    

    
    
    // Обновление сериалов
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
    
    //Обновление фильмов
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
            cell.textLabel?.text = movies[indexPath.row].title
        return cell
        default:
        return UITableViewCell()
        }
        
        
    }
    
    @IBAction func TVMovieSegmentedChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let identifier = String(describing: TVDetailsViewController.self)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(identifier: identifier) as? TVDetailsViewController {
            detailViewController.tv = self.tvies[indexPath.row]
//            detailViewController.tvMovie = self.tvies[indexPath.row]


            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    
    
}

//!
