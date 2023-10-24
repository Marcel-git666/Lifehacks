//
//  Answer.swift
//  Lifehacks
//
//  Created by Marcel Mravec on 17.10.2023.
//

import Foundation

struct Answer: Identifiable, Votable {
    let id: Int
    let body: String
    let creationDate: Date
    let isAccepted: Bool
    let owner: User?
    var score: Int
    var vote: Vote?
}

extension Answer: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "answer_id"
        case body = "body_markdown"
        case creationDate = "creation_date"
        case isAccepted = "is_accepted"
        case owner, score
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.body = try container.decode(String.self, forKey: .body)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.isAccepted = try container.decode(Bool.self, forKey: .isAccepted)
        self.score = try container.decode(Int.self, forKey: .score)
        do {
            owner = try container.decodeIfPresent(User.self, forKey: .owner)
        } catch User.DecodingError.userDoesNotExist {
            owner = nil
        }
    }
}

extension Answer {
    static var preview: Answer {
        Question.preview.answers[0]
    }
}
