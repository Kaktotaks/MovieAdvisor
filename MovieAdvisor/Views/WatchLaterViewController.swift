//
//  WatchLaterViewController.swift
//  TMDB my self
//
//  Created by Леонід Шевченко on 10.08.2021.
//

import UIKit
import RealmSwift
import Alamofire

class WatchLaterViewController: UIViewController {
    
    //Realm properties
    var tvShowsRealm: [TVShowsRealm] = []
    var moviesRealm: [MoviesRealm] = []
    
//    DB properties
    var tvShows: [TVShow] = []
    var movies: [Movie] = []
    
    
    let realm = try? Realm()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TMWLSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.ui.defaultCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tvShowsRealm = self.getTVShows()
        self.moviesRealm = self.getMovies()
        self.tableView.reloadData()
    }
    
    //MARK: -
    private func getTVShows() -> [TVShowsRealm] {
        
        var TVs = [TVShowsRealm]()
        guard let TVsResults = realm?.objects(TVShowsRealm.self) else { return [] }
        for tv in TVsResults {
            TVs.append(tv)
        }
        return TVs
    }
    //MARK: -
    private func getMovies() -> [MoviesRealm] {
        
        var movies = [MoviesRealm]()
        guard let moviesResults = realm?.objects(MoviesRealm.self) else { return [] }
        for movie in moviesResults {
            movies.append(movie)
        }
        return movies
    }
    
}

extension WatchLaterViewController: UITableViewDataSource {
    
    @IBAction func TMWLSegmentedControlChanged(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = self.TMWLSegmentedControl.selectedSegmentIndex
        switch selectedIndex
        {
        case 0:
            return tvShowsRealm.count
        case 1:
            return moviesRealm.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ui.defaultCellIdentifier, for: indexPath )
        
        
        
        let selectedIndex = self.TMWLSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            cell.textLabel?.text = tvShowsRealm[indexPath.row].name
            return cell
        case 1:
            cell.textLabel?.text = moviesRealm[indexPath.row].name
            return cell
        default:
            return UITableViewCell()
        }
    }
    // Добавил в UITableViewDataSource
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let selectedIndex = self.TMWLSegmentedControl.selectedSegmentIndex
        if editingStyle == .delete {
            switch selectedIndex {
            case 0:

                self.deleteTVShows(objectID: self.tvShowsRealm[indexPath.row].id)
                self.tvShowsRealm = self.getTVShows()
            case 1:
                self.deleteMovie(objectID: self.moviesRealm[indexPath.row].id)
                self.moviesRealm = self.getMovies()

            default: break
            }
            
        }
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func deleteTVShows(objectID: Int) {
        let object = realm?.objects(TVShowsRealm.self).filter("id = %@", objectID).first
        try! realm!.write {
            realm?.delete(object!)
        }
    }
    
    func deleteMovie(objectID: Int) {
        let object = realm?.objects(MoviesRealm.self).filter("id = %@", objectID).first
        try! realm!.write {
            realm?.delete(object!)
        }
    }
}
    

extension WatchLaterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
        
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let object = self.TMWLSegmentedControl
        let selectedIndex = self.TMWLSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex
        {
        case 0:
            let tvObject = self.tvShowsRealm[indexPath.row]
            let tvCodableObject = TVShow(from: tvObject)
            
            let TVidentifier = String(describing: TVShowDetailsViewController.self)
            if let detailViewController = storyboard.instantiateViewController(identifier: TVidentifier) as? TVShowDetailsViewController {
                detailViewController.tvShow = self.tvShows[indexPath.row]
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            
            // push wievcontrollers
        case 1:
            let movieObject = self.moviesRealm[indexPath.row]
            let movieCodableObject = Movie(from: movieObject)
            
            let movieidentifier = String(describing: MovieDetailsViewController.self)
            if let detailViewController = storyboard.instantiateViewController(identifier: movieidentifier) as? MovieDetailsViewController {
                detailViewController.movie = self.movies[indexPath.row]
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        default:
            return
        }
    }
}

//MARK: - Переход на DetailViewControllers ?
