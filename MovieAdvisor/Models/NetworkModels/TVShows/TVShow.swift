import Foundation

struct TVShow: Codable {
	var name : String?
    var firstAirDate : String?
    var genreIds : [Int]?
    var originalLanguage : String?
    var voteCount : Int?
    var posterPath : String?
    var id : Int?
    var overview : String?
    var voteAverage : Double?
    var originalName : String?
    var originCountry : [String]?
    var backdropPath : String?
    var popularity : Double?
    var mediaType : String?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case firstAirDate = "first_air_date"
		case genreIds = "genre_ids"
		case originalLanguage = "original_language"
		case voteCount = "vote_count"
		case posterPath = "poster_path"
		case id = "id"
		case overview = "overview"
		case voteAverage = "vote_average"
		case originalName = "original_name"
		case originCountry = "origin_country"
		case backdropPath = "backdrop_path"
		case popularity = "popularity"
		case mediaType = "media_type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        firstAirDate = try values.decodeIfPresent(String.self, forKey: .firstAirDate)
        genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
        originCountry = try values.decodeIfPresent([String].self, forKey: .originCountry)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
	}

    init(from tvShowsRealm: TVShowsRealm) {
        self.name = tvShowsRealm.name
        self.popularity = tvShowsRealm.popularity
        self.overview = tvShowsRealm.overview
        self.id = tvShowsRealm.id
        self.backdropPath = tvShowsRealm.backdropPath
        self.mediaType = tvShowsRealm.mediaType
        self.posterPath = tvShowsRealm.posterPath
    }
    
}
