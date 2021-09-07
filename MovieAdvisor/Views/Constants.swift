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

        static let defaultImagePath = "https://image.tmdb.org/t/p/original/"
        static let defaultPath = "https://api.themoviedb.org/3/"
    }
    
    struct viewControllerTitles {
        static let media = "Movie Advisor"
        static let watchLater = "Watch later"
    }
    
    struct ui {
        static let defaultCellIdentifier = "Cell"
        static let okMessage = "Cool 👌"
        
        static let movieSavedMessage = "Movie saved !"
        static let tvShowSavedMessage = "TV Show saved !"
        
    }
    
}
