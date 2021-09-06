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
    var tvsRealm: [TVRealm] = []
    var movieRealm: [MovieRealm] = []
    
    //DB properties
    var tvies: [TV] = []
    var movies: [Movie] = []
    
    
    let realm = try? Realm()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TMWLSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tvsRealm = self.getTVs()
        self.movieRealm = self.getMovies()
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

extension WatchLaterViewController: UITableViewDataSource {
    
    @IBAction func TMWLSegmentedControlChanged(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = self.TMWLSegmentedControl.selectedSegmentIndex
        switch selectedIndex
        {
        case 0:
            return tvsRealm.count
        case 1:
            return movieRealm.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath )
        
        
        
        let selectedIndex = self.TMWLSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            cell.textLabel?.text = tvsRealm[indexPath.row].name
            return cell
        case 1:
            cell.textLabel?.text = movieRealm[indexPath.row].name
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

                self.deleteTV(objectID: self.tvsRealm[indexPath.row].id)
                self.tvsRealm = self.getTVs()
            case 1:
                self.deleteMovie(objectID: self.movieRealm[indexPath.row].id)
                self.movieRealm = self.getMovies()

            default: break
            }
            
        }
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func deleteTV(objectID: Int) {
        let object = realm?.objects(TVRealm.self).filter("id = %@", objectID).first
        try! realm!.write {
            realm?.delete(object!)
        }
    }
    
    func deleteMovie(objectID: Int) {
        let object = realm?.objects(MovieRealm.self).filter("id = %@", objectID).first
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
//        let object = self.TMWLSegmentedControl
//        let selectedIndex = self.TMWLSegmentedControl.selectedSegmentIndex
//        switch selectedIndex
//        {
//        case 0:
//            let tvObject = self.tvsRealm[indexPath.row]
//            let tvCodableObject = TV(from: tvObject)
//            // push wievcontrollers
//        case 1:
//            let tvObject = self.tvsRealm[indexPath.row]
//            let tvCodableObject = TV(from: tvObject)
//        default:
//            return
//        }
    }
}

//MARK: - Переход на DetailViewControllers ?
