//
//  WatchLaterViewController.swift
//  TMDB my self
//
//  Created by Леонід Шевченко on 10.08.2021.
//

import UIKit
import RealmSwift
import SWTableViewCell

class WatchLaterViewController: UIViewController {
    
    var tvs: [TVRealm] = []
    var movies: [MovieRealm] = []
    
    var lub: NSMutableArray = []
    var rub: NSMutableArray = []

    func fillArrays() {
        let _rub = NSMutableArray()
        _rub.sw_addUtilityButton(with: .red, title: "Red")
        _rub.sw_addUtilityButton(with: .orange, title: "Orange")
        rub = _rub

        let _lub = NSMutableArray()
        _lub.sw_addUtilityButton(with: .green, title: "Green")
        _lub.sw_addUtilityButton(with: .blue, title: "Blue")
        lub = _lub
    }
    
    
    let realm = try? Realm()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TMWLSegmentedControl: UISegmentedControl!
    
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
    
    @IBAction func TMWLSegmentedControlChanged(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = self.TMWLSegmentedControl.selectedSegmentIndex
        switch selectedIndex
        {
        case 0:
            return tvs.count
        case 1:
            return movies.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath ) as! SWTableViewCell
        
        fillArrays()
        cell.leftUtilityButtons = lub as! [Any]
        cell.rightUtilityButtons = rub as! [Any]
                
        
        
        let selectedIndex = self.TMWLSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            case 0:
                cell.textLabel?.text = tvs[indexPath.row].name
                return cell
            case 1:
                cell.textLabel?.text = movies[indexPath.row].name
                return cell
            default:
                return UITableViewCell()
            }
    }
    
    
    
}


// MARK: - Savig
// MARK: - Savig
// MARK: - Savig
