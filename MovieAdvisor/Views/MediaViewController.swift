//
//  ViewController.swift
//  TMDB my self
//
//  Created by Леонід Шевченко on 03.08.2021.
//

import UIKit
import Alamofire
import RealmSwift

class MediaViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "popcorn")
        return imageView
    }()
    
    
    var tvShows: [TVShow] = []
    var movies: [Movie] = []
    
    let realm = try? Realm()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tvShowMovieSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        
        let tvTableViewCellIdentifier = String(describing: TVShowTableViewCell.self)
        self.tableView.register(UINib(nibName: tvTableViewCellIdentifier, bundle: nil),
                                forCellReuseIdentifier: tvTableViewCellIdentifier)
        
        let movieTableViewCellIdentifier = String(describing: MovieTableViewCell.self)
        self.tableView.register(UINib(nibName: movieTableViewCellIdentifier, bundle: nil),
                                forCellReuseIdentifier: movieTableViewCellIdentifier)
        
        
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.ui.defaultCellIdentifier)
        
        
        self.title = Constants.viewControllerTitles.media
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK:- Add launchScreen animation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        launchScreenAnimate() // animate()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
            self.launchScreenAnimate()
        })
    }
    
    private func launchScreenAnimate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2.5
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
            
            self.imageView.alpha = 0
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestTrendingTVShows()
        self.requestTrendingMovies()
        
    }
    
    
    
    //MARK: - Network request for reloading TVs
    func requestTrendingTVShows() {
        
        let url = "\(Constants.network.trendingTVShowPath)\(Constants.network.apiKey)"
        AF.request(url).responseJSON { responce in
            
            let decoder = JSONDecoder()
            
            if let data = try? decoder.decode(PopularTVShowResult.self, from: responce.data!){
                self.tvShows = data.tvShows ?? []
                self.tableView.reloadData()
            }
            
        }
    }
    
    //MARK: - Network request for reloading movies
    func requestTrendingMovies() {
        
        let url = "\(Constants.network.trendingMoviePath)\(Constants.network.apiKey)"
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
extension MediaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = self.tvShowMovieSegmentedControl.selectedSegmentIndex
        switch selectedIndex
        {
        case 0:
            return self.tvShows.count
        case 1:
            return self.movies.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedIndex = self.tvShowMovieSegmentedControl.selectedSegmentIndex
        switch selectedIndex {
        
        case 0:
            let tvShowCell = tableView.dequeueReusableCell(withIdentifier: "TVShowTableViewCell", for: indexPath) as! TVShowTableViewCell
            
            // UI for TVShows
            let tvShowMedia = self.tvShows[indexPath.row]
            let tvShowImagePathString = Constants.network.defaultImagePath + tvShowMedia.posterPath!
            tvShowCell.tvShowConfigureWith(imageURL: URL(string: tvShowImagePathString),
                                           TVName: tvShowMedia.name,
                                           desriptionText: tvShowMedia.overview)
            
            return tvShowCell
            
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
    
    @IBAction func tvShowMovieSegmentedChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
}
//MARK: - Delegate for tableView
extension MediaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let selectedIndex = self.tvShowMovieSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            let tvIdentifier = String(describing: TVShowDetailsViewController.self)
            
            if let detailViewController = storyboard.instantiateViewController(identifier: tvIdentifier) as? TVShowDetailsViewController {
                detailViewController.tvShow = self.tvShows[indexPath.row]
                
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        case 1:
            let movieIdentifier = String(describing: MovieDetailsViewController.self)
            
            if let detailViewController = storyboard.instantiateViewController(identifier: movieIdentifier) as? MovieDetailsViewController {
                detailViewController.movie = self.movies[indexPath.row]
                
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            
        default:
            break
        }
    }
    
    //MARK: HeightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  540
    }
    
    //MARK:- Appearing cells animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedIndex = self.tvShowMovieSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            let TVidentifier = String(describing: TVShowDetailsViewController.self)
            
            if storyboard.instantiateViewController(identifier: TVidentifier) is TVShowDetailsViewController {
                
                let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 50, 0)
                cell.layer.transform = rotationTransform
                cell.alpha = 0.5
                
            }
            
        case 1:
            let movieidentifier = String(describing: MovieDetailsViewController.self)
            
            if storyboard.instantiateViewController(identifier: movieidentifier) is MovieDetailsViewController {
                let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, +500, 50, 0)
                cell.layer.transform = rotationTransform
                cell.alpha = 0.5
            }
            
        default:
            let TVidentifier = String(describing: TVShowDetailsViewController.self)
            
            if storyboard.instantiateViewController(identifier: TVidentifier) is TVShowDetailsViewController {
                
                let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 50, 0)
                cell.layer.transform = rotationTransform
                cell.alpha = 0.5
                
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}
    

