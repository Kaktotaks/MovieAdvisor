//
//  Constants.swift
//  MovieAdvisor
//
//  Created by Леонід Шевченко on 03.09.2021.
//

import Foundation

struct Constants {
    
    struct network {
        
        static let apiKey = "242869b42a65c82d7bfdc955a766ce9f"
        static let baseImageURL = "https://image.tmdb.org/t/p/w500/"
        static let defaultImagePath = "https://image.tmdb.org/t/p/original/"
        static let defaultPath = "https://api.themoviedb.org/3/"
        static let keyForVideos = "/videos?api_key=\(apiKey)&language=en-US"
        
        static let tvShowPath = defaultPath + "tv/"
        static let trendingTVShowPath = "https://api.themoviedb.org/3/trending/tv/week?api_key="
        
        static let moviePath = defaultPath + "movie/"
        static let trendingMoviePath = "https://api.themoviedb.org/3/trending/movie/week?api_key="
        
        
    }
    
    struct viewControllerTitles {
        static let media = "Movie Advisor"
        static let watchLater = "Watch Later"
    }
    
    struct ui {
        static let defaultCellIdentifier = "Cell"
        static let okMessage = "Cool 👌"
        
        static let movieSavedMessage = "Movie saved in \(viewControllerTitles.watchLater) !"
        static let tvShowSavedMessage = "TV Show saved in \(viewControllerTitles.watchLater) !"
        
    }
    
}
