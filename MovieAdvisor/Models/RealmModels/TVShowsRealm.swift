//
//  TVRealm.swift
//  MovieAdvisor
//
//  Created by Леонід Шевченко on 10.08.2021.
//

import Foundation
import RealmSwift

class TVShowsRealm: Object {
    @objc dynamic var id: Int  = 0
    @objc dynamic var name: String = ""
    @objc dynamic var popularity: Double = 0.0
    @objc dynamic var overview: String?
    @objc dynamic var backdropPath : String?
    @objc dynamic var mediaType: String?
    @objc dynamic var posterPath: String?
    }
