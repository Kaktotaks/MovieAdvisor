//
//  MovieRealm.swift
//  MovieAdvisor
//
//  Created by Леонід Шевченко on 30.08.2021.
//

import Foundation
import RealmSwift

class MoviesRealm: Object {
    @objc dynamic var adult: Bool = true
    @objc dynamic var originalLanguage: String?
    @objc dynamic var originalTitle: String?
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var video: Bool = true
    @objc dynamic var voteAverage: Double = 0.0
    @objc dynamic var voteCount: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var popularity: Double = 0.0
    @objc dynamic var overview: String?
    @objc dynamic var id: Int = 0
    @objc dynamic var backdrop_path : String?
    @objc dynamic var posterPath: String?
}
