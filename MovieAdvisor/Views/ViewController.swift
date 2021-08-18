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
    var movies: [Movie] = []//add movies
    
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
    
    //запрос на популярные фильмы
    func requestTrendingMovies() {
        
        let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=242869b42a65c82d7bfdc955a766ce9f"

        // Выполним запрос по URL который мы создали выше:
        AF.request(url).responseJSON { responce in

            // Переменная responce имеет тип JSON, приводим ее к типу PopularMovieResult
            let decoder = JSONDecoder()

            if let data = try? decoder.decode(PopularMovieResult.self, from: responce.data!) {

                // Если получилось привести, сохраняем в локальную переменную movies список фильмов, который мы получили из интернета:
                self.movies = data.movies ?? []

                // Локальный список обновлен, теперь перезагрузим данные для таблицы:
                self.tableView.reloadData()
            }
        }
    }
    
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvies.count
//        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        
        
        cell.textLabel?.text = self.tvies[indexPath.row].name
//        cell.textLabel?.text = self.movies[indexPath.row].title
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let identifier = String(describing: TVDetailsViewController.self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailViewController = storyboard.instantiateViewController(identifier: identifier) as? TVDetailsViewController {
            detailViewController.tv = self.tvies[indexPath.row]
//            detailViewController.movie = self.movies[indexPath.row]
            
            
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

//!
