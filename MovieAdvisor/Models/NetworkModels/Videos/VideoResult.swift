import Foundation

struct VideoResult : Codable {
	let id : Int?
	let videos : [Video]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case videos = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
        videos = try values.decodeIfPresent([Video].self, forKey: .videos)
	}

}
