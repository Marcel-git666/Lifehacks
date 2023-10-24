//
//  User.swift
//  Lifehacks
//
//  Created by Marcel Mravec on 21.09.2023.
//

import Foundation

struct User: Equatable {
    let id: Int
    let reputation: Int
    var name: String
    var aboutMe: String?
    let profileImageURL: URL?
}

extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case reputation
        case name = "display_name"
        case aboutMe = "about_me"
        case profileImageURL = "profile_image"
        case userType = "user_type"
    }
    enum DecodingError: Error {
        case userDoesNotExist
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let userType = try container.decode(String.self, forKey: .userType)
        guard userType != "does_not_exist" else {
            throw DecodingError.userDoesNotExist
        }
        id = try container.decode(Int.self, forKey: .id)
        reputation = try container.decode(Int.self, forKey: .reputation)
        name = try container.decode(String.self, forKey: .name)
        profileImageURL = try container.decodeIfPresent(URL.self, forKey: .profileImageURL)
        aboutMe = try container.decodeIfPresent(String.self, forKey: .aboutMe)
    }
}

extension User {
    struct Wrapper: Decodable {
        let items: [User]

        enum CodingKeys: String, CodingKey {
            case items
        }
    }
}

extension User {
    static var preview: User {
        User(
            id: 0,
            reputation: 0,
            name: "Claude Bluebeard",
            aboutMe: "The monkey-rope is found in all whalers; but it was only in the Pequod that the monkey and his holder were ever tied together. This improvement upon the original usage was introduced by no less a man than Stubb, in order to afford the imperilled harpooneer the strongest possible guarantee for the faithfulness and vigilance of his monkey-rope holder.",
            profileImageURL: Bundle.main.url(forResource: "avatar", withExtension: "jpg")!)
    }
}
