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


class TVShowDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var filmLanguageLabel: UILabel!
    @IBOutlet weak var firstAirDateLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var videoPlayerView: YTPlayerView!
    
    let realm = try? Realm()
    
    var tvShow: TVShow? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let id = self.tvShow?.id {
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
        
        
        self.title = self.tvShow?.name
        self.descriptionLabel.text = self.tvShow?.overview
        self.filmLanguageLabel.text = self.tvShow?.originalLanguage
        self.firstAirDateLabel.text = self.tvShow?.firstAirDate
        self.voteAverageLabel.text = String(describing:self.tvShow!.voteAverage!)
        
        if let posterPath = self.tvShow?.posterPath {

            // Тогда создадим полную ссылку на картинку
            let urlString = Constants.network.baseImageURL + posterPath

            // И с помощью библиотеки SDWebImage задаем posterImageView картинку, загруженную по url
            self.posterImageView.sd_setImage(with: URL(string: urlString), completed: nil)

        }
        
        self.title = self.tvShow?.name
  
        let logoutBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addToWatchLaterButtonPressed))

        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
    }
    
    @IBAction func addToWatchLaterButtonPressed(_ sender: Any) {
        let tvRealm = TVShowsRealm()
        tvRealm.name = self.tvShow?.name ?? ""
        tvRealm.popularity = self.tvShow?.popularity ?? 0.0
        tvRealm.overview = self.tvShow?.overview ?? ""
        tvRealm.id = self.tvShow?.id ?? 0
        tvRealm.backdropPath = self.tvShow?.backdropPath ?? ""
        tvRealm.mediaType = self.tvShow?.mediaType ?? ""
        tvRealm.posterPath = self.tvShow?.posterPath ?? ""

        try? realm?.write {
            realm?.add(tvRealm)
        }
        self.showAlert()
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: Constants.ui.tvShowSavedMessage, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constants.ui.okMessage, style: .cancel, handler: { action in
            print("Tapped \(Constants.ui.okMessage)")
        }))
        
        present(alert, animated: true)
    }
}







