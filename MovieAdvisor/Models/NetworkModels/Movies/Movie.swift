import Foundation

struct Movie : Codable {
	let adult : Bool?
	let backdrop_path : String?
	let id : Int?
	let original_language : String?
	let original_title : String?
	let overview : String?
	let popularity : Double?
	let poster_path : String?
	let release_date : String?
	let name : String?
	let video : Bool?
	let vote_average : Double?
	let vote_count : Int?

	enum CodingKeys: String, CodingKey {

		case adult = "adult"
		case backdrop_path = "backdrop_path"
		case id = "id"
		case original_language = "original_language"
		case original_title = "original_title"
		case overview = "overview"
		case popularity = "popularity"
		case poster_path = "poster_path"
		case release_date = "release_date"
		case name = "title"
		case video = "video"
		case vote_average = "vote_average"
		case vote_count = "vote_count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
		backdrop_path = try values.decodeIfPresent(String.self, forKey: .backdrop_path)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		original_language = try values.decodeIfPresent(String.self, forKey: .original_language)
		original_title = try values.decodeIfPresent(String.self, forKey: .original_title)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
		poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
		release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
        name = try values.decodeIfPresent(String.self, forKey: .name)
		video = try values.decodeIfPresent(Bool.self, forKey: .video)
		vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
		vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
	}
    
    
    init(from moviesRealm: MoviesRealm) {
        
        self.adult = moviesRealm.adult
        self.original_language = moviesRealm.originalLanguage
        self.original_title = moviesRealm.originalTitle
        self.release_date = moviesRealm.releaseDate
        self.video = moviesRealm.video
        self.vote_average = moviesRealm.voteAverage
        self.vote_count = moviesRealm.voteCount
        self.name = moviesRealm.name
        self.popularity = moviesRealm.popularity
        self.overview = moviesRealm.overview
        self.id = moviesRealm.id
        self.backdrop_path = moviesRealm.backdrop_path
        self.poster_path = moviesRealm.posterPath
    }

}
