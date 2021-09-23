//
//  MovieDetailsViewController.swift
//  MovieAdvisor
//
//  Created by Леонід Шевченко on 30.08.2021.
//

import UIKit
import SDWebImage
import RealmSwift
import youtube_ios_player_helper
import Alamofire


class MovieDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var filmLanguageLabel: UILabel!
    @IBOutlet weak var firstAirDateLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var videoPlayerView: YTPlayerView!
    
    let realm = try? Realm()
    var movie: Movie? = nil
    
    //MARK: - Class Life Сycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let id = self.movie?.id {
            let stringID = String(describing: id)
            self.requestVideos(with: stringID)
        }
    }
    
    // API request for videos
    func requestVideos(with id: String) {
        
        let url = "\(Constants.Network.moviePath)\(id)\(Constants.Network.keyForVideos)"
        
        AF.request(url).responseJSON { responce in

            let decoder = JSONDecoder()
            
            if let data = try? decoder.decode(VideoResult.self, from: responce.data!){
                let id = data.videos?.first?.key
                self.videoPlayerView.load(withVideoId: id!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.title = self.movie?.name
        self.descriptionLabel.text = self.movie?.overview
        self.filmLanguageLabel.text = self.movie?.original_language
        self.firstAirDateLabel.text = self.movie?.release_date
        self.voteAverageLabel.text = String(describing:self.movie!.vote_average!)
        
        if let posterPath = self.movie?.poster_path {

            // Created a full link to the picture
            let urlString = Constants.Network.baseImageURL + posterPath

            // And using the SDWebImage library, we set posterImageView an image loaded by url
            self.posterImageView.sd_setImage(with: URL(string: urlString), completed: nil)

        }
        // Set the navigation bar title
        self.title = self.movie?.name
  
        // Set the button "+" to add TV Show to "Watch Later" (Realm)
        let logoutBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addToWatchLaterButtonPressed))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
    // Add TV Show to realm by clicking "+" button
    @IBAction func addToWatchLaterButtonPressed(_ sender: Any) {
        let movieRealm = MoviesRealm()
        movieRealm.name = self.movie?.name ?? ""
        movieRealm.popularity = self.movie?.popularity ?? 0.0
        movieRealm.overview = self.movie?.overview ?? ""
        movieRealm.id = self.movie?.id ?? 0
        movieRealm.backdrop_path = self.movie?.backdrop_path ?? ""
        movieRealm.posterPath = self.movie?.poster_path ?? ""
        movieRealm.voteAverage = self.movie?.vote_average ?? 0.0 //!
        movieRealm.originalLanguage = self.movie?.original_language //!
        movieRealm.releaseDate = self.movie?.release_date ?? "" //!

        try? realm?.write {
            realm?.add(movieRealm)
        }
        
        self.showAlert()
    }
    
    // Show alert func
    func showAlert() {
        let alert = UIAlertController(title: Constants.UI.movieSavedMessage, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constants.UI.okMessage, style: .cancel, handler: { action in
            print("Tapped \(Constants.UI.okMessage)")
        }))
        
        present(alert, animated: true)
    }
    
    
}
