//
//  NetworkManager.swift
//  MovieAdvisor
//
//  Created by Леонід Шевченко on 21.09.2021.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    //MARK: - Network request for reloading TVs
    func requestTrendingTVShows(completion: @escaping(([TVShow]) -> ())) {
        
        let url = "\(Constants.Network.trendingTVShowPath)\(Constants.Network.apiKey)"
        AF.request(url).responseJSON { responce in
            
            let decoder = JSONDecoder()
            
            if let data = try? decoder.decode(PopularTVShowResult.self, from: responce.data!){
               let tvShows = data.tvShows ?? []
                completion(tvShows)
            }
        }
    }
    
    //MARK: - Network request for reloading movies
    func requestTrendingMovies(completion: @escaping(([Movie]) -> ())) {
        
        let url = "\(Constants.Network.trendingMoviePath)\(Constants.Network.apiKey)"
        AF.request(url).responseJSON { responce in
            
            let decoder = JSONDecoder()
            
            if let data = try? decoder.decode(PopularMovieResult.self, from: responce.data!){
                let movies = data.movies ?? []
                 completion(movies)
            }
        }
    }
    
}
