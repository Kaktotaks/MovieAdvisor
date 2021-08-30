//
//  WatchLaterViewController.swift
//  TMDB my self
//
//  Created by Леонід Шевченко on 10.08.2021.
//

import UIKit
import RealmSwift

class WatchLaterViewController: UIViewController {
    
    var tvs: [TVRealm] = []
    var movies: [MovieRealm] = []
    
    let realm = try? Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tvs = self.getTVs()
        self.movies = self.getMovies()
        self.tableView.reloadData()
    }
    
    //MARK: -
    private func getTVs() -> [TVRealm] {
        
        var TVs = [TVRealm]()
        guard let TVsResults = realm?.objects(TVRealm.self) else { return [] }
        for tv in TVsResults {
            TVs.append(tv)
        }
        return TVs
    }
    //MARK: -
    private func getMovies() -> [MovieRealm] {
        
        var movies = [MovieRealm]()
        guard let moviesResults = realm?.objects(MovieRealm.self) else { return [] }
        for movie in moviesResults {
            movies.append(movie)
        }
        return movies
    }
    
    
    
}

extension WatchLaterViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvs.count
//        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = self.tvs[indexPath.row].name
        return cell ?? UITableViewCell()
    }
    
    
}
