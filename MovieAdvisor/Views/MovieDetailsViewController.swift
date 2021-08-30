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
    
    let baseImageURL = "https://image.tmdb.org/t/p/w500/"
    
    var movie: Movie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let id = self.movie?.id {
            let stringID = String(describing: id)
            self.requestVideos(with: stringID)
        }
    }
    
    func requestVideos(with id: String) {
        
        let url = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=242869b42a65c82d7bfdc955a766ce9f&language=en-US"
        
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
        
        
        self.title = self.movie?.title
        self.descriptionLabel.text = self.movie?.overview
        self.filmLanguageLabel.text = self.movie?.original_language
        self.firstAirDateLabel.text = self.movie?.release_date
        self.voteAverageLabel.text = String(describing:self.movie!.vote_average!)
        
        if let posterPath = self.movie?.poster_path {

            // Тогда создадим полную ссылку на картинку
            let urlString = self.baseImageURL + posterPath

            // И с помощью библиотеки SDWebImage задаем posterImageView картинку, загруженную по url
            self.posterImageView.sd_setImage(with: URL(string: urlString), completed: nil)

        }
        
        self.title = self.movie?.title
  
        let logoutBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addToWatchLaterButtonPressed))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        
        
    }
    
    @IBAction func addToWatchLaterButtonPressed(_ sender: Any) {
        let movieRealm = MovieRealm()
        movieRealm.name = self.movie?.title ?? ""
        movieRealm.popularity = self.movie?.popularity ?? 0.0
        movieRealm.overview = self.movie?.overview ?? ""
        movieRealm.id = self.movie?.id ?? 0
        movieRealm.backdrop_path = self.movie?.backdrop_path ?? ""
        movieRealm.posterPath = self.movie?.poster_path ?? ""

        try? realm?.write {
            realm?.add(movieRealm)
        }
    }
    
    
    
    
    
    
}
