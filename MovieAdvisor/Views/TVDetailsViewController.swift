//
//  MovieDetailsViewController.swift
//  TMDB my self
//
//  Created by Леонід Шевченко on 03.08.2021.
//

import UIKit
import SDWebImage
import RealmSwift
import youtube_ios_player_helper
import Alamofire


class TVDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var filmLanguageLabel: UILabel!
    @IBOutlet weak var firstAirDateLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var videoPlayerView: YTPlayerView!
    
    let realm = try? Realm()
    
    let baseImageURL = "https://image.tmdb.org/t/p/w500/"
    
    var tvMovie: TV? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let id = self.tvMovie?.id {
            let stringID = String(describing: id)
            self.requestVideos(with: stringID)
        }

        
    }
    
    func requestVideos(with id: String) {
        
        let url = "https://api.themoviedb.org/3/tv/\(id)/videos?api_key=242869b42a65c82d7bfdc955a766ce9f&language=en-US"
        
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
        
        
        self.title = self.tvMovie?.name
        self.descriptionLabel.text = self.tvMovie?.overview
        self.filmLanguageLabel.text = self.tvMovie?.original_language
        self.firstAirDateLabel.text = self.tvMovie?.first_air_date
        self.voteAverageLabel.text = String(describing:self.tvMovie!.vote_average!)
        
        if let posterPath = self.tvMovie?.posterPath {

            // Тогда создадим полную ссылку на картинку
            let urlString = self.baseImageURL + posterPath

            // И с помощью библиотеки SDWebImage задаем posterImageView картинку, загруженную по url
            self.posterImageView.sd_setImage(with: URL(string: urlString), completed: nil)

        }
        
        self.title = self.tvMovie?.name
  
        let logoutBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addToWatchLaterButtonPressed))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        
        
    }
    
    @IBAction func addToWatchLaterButtonPressed(_ sender: Any) {
        let tvRealm = TVRealm()
        tvRealm.name = self.tvMovie?.name ?? ""
        tvRealm.popularity = self.tvMovie?.popularity ?? 0.0
        tvRealm.overview = self.tvMovie?.overview ?? ""
        tvRealm.id = self.tvMovie?.id ?? 0
        tvRealm.backdrop_path = self.tvMovie?.backdrop_path ?? ""
        tvRealm.media_type = self.tvMovie?.media_type ?? ""
        tvRealm.posterPath = self.tvMovie?.posterPath ?? ""

        try? realm?.write {
            realm?.add(tvRealm)
        }
    }
    
}




