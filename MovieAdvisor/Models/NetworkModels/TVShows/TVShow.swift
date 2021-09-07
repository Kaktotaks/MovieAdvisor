import Foundation

struct TVShow: Codable {
	var name : String?
    var first_air_date : String?
    var genre_ids : [Int]?
    var original_language : String?
    var vote_count : Int?
    var posterPath : String?
    var id : Int?
    var overview : String?
    var vote_average : Double?
    var original_name : String?
    var origin_country : [String]?
    var backdrop_path : String?
    var popularity : Double?
    var media_type : String?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case first_air_date = "first_air_date"
		case genre_ids = "genre_ids"
		case original_language = "original_language"
		case vote_count = "vote_count"
		case posterPath = "poster_path"
		case id = "id"
		case overview = "overview"
		case vote_average = "vote_average"
		case original_name = "original_name"
		case origin_country = "origin_country"
		case backdrop_path = "backdrop_path"
		case popularity = "popularity"
		case media_type = "media_type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		first_air_date = try values.decodeIfPresent(String.self, forKey: .first_air_date)
		genre_ids = try values.decodeIfPresent([Int].self, forKey: .genre_ids)
		original_language = try values.decodeIfPresent(String.self, forKey: .original_language)
		vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
		vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
		original_name = try values.decodeIfPresent(String.self, forKey: .original_name)
		origin_country = try values.decodeIfPresent([String].self, forKey: .origin_country)
		backdrop_path = try values.decodeIfPresent(String.self, forKey: .backdrop_path)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
		media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
	}

    init(from tvRealm: TVShowsRealm) {
        self.name = tvRealm.name
        self.popularity = tvRealm.popularity
        self.overview = tvRealm.overview
        self.id = tvRealm.id
        self.backdrop_path = tvRealm.backdrop_path
        self.media_type = tvRealm.media_type
        self.posterPath = tvRealm.posterPath
    }
    
}
