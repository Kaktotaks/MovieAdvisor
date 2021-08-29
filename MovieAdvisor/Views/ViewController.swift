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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        
        self.title = "Movies/TVs"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestTrendingTVies()
        
    }
    
    @IBAction func TVorMovieSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.requestTrendingTVies()
        } else {

            self.requestTrendingMovies()
        }
        
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
        return self.tvies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        
        
        cell.textLabel?.text = self.tvies[indexPath.row].name
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let identifier = String(describing: TVDetailsViewController.self)
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let detailViewController = storyboard.instantiateViewController(identifier: identifier) as? TVDetailsViewController {
//            detailViewController.tvMovie = self.tvies[indexPath.row]
//
//
//            self.navigationController?.pushViewController(detailViewController, animated: true)
//        }
//    }
    
    
    
}

//!
