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
        
        let url = "\(Constants.network.tvShowPath)\(id)\(Constants.network.keyForVideos)"
        
        AF.request(url).responseJSON { responce in

            let decoder = JSONDecoder()
            guard let data = responce.data else { return }
            
            if let data = try? decoder.decode(VideoResult.self, from: data) {
                guard let id = data.videos?.first?.key else { return }
                self.videoPlayerView.load(withVideoId: id)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.title = self.tvShow?.name
        self.descriptionLabel.text = self.tvShow?.overview
        self.filmLanguageLabel.text = self.tvShow?.original_language
        self.firstAirDateLabel.text = self.tvShow?.first_air_date
        
        if let tvShow = self.tvShow {
            if let vote = tvShow.vote_average {
                self.voteAverageLabel.text = String(describing: vote)
            }
        }
        
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
        let tvShowRealm = TVShowsRealm()
        tvShowRealm.name = self.tvShow?.name ?? ""
        tvShowRealm.popularity = self.tvShow?.popularity ?? 0.0
        tvShowRealm.overview = self.tvShow?.overview ?? ""
        tvShowRealm.id = self.tvShow?.id ?? 0
        tvShowRealm.backdrop_path = self.tvShow?.backdrop_path ?? ""
        tvShowRealm.media_type = self.tvShow?.media_type ?? ""
        tvShowRealm.posterPath = self.tvShow?.posterPath ?? ""

        try? realm?.write {
            realm?.add(tvShowRealm)
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







