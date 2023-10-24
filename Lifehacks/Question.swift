//
//  Question.swift
//  Lifehacks
//
//  Created by Marcel Mravec on 21.09.2023.
//

import Foundation


enum Vote: Int {
    case up = 1
    case down = -1
}

protocol Votable {
    var score: Int { get set }
    var vote: Vote? { get set }
}

extension Votable {
    mutating func unvote() {
        guard let vote else { return }
        score -= vote.rawValue
        self.vote = nil
    }

    mutating func upvote() {
        cast(vote: .up)
    }

    mutating func downvote() {
        cast(vote: .down)
    }
}

private extension Votable {
    mutating func cast(vote: Vote) {
        guard self.vote != vote else { return }
        unvote()
        score += vote.rawValue
        self.vote = vote
    }
}

struct Question: Identifiable, Votable {
    
    let isAnswered: Bool
    let id: Int
    let viewCount: Int
    let answerCount: Int
    let title: String
    let body: String
    let creationDate: Date
    let owner: User?
    var score: Int
    var vote: Vote?
    let answers: [Answer]
    
}

extension Question: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "question_id"
        case viewCount = "view_count"
        case answerCount = "answer_count"
        case isAnswered = "is_answered"
        case creationDate = "creation_date"
        case body = "body_markdown"
        case title, score, owner, answers
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        score = try container.decode(Int.self, forKey: .score)
        viewCount = try container.decode(Int.self, forKey: .viewCount)
        answerCount = try container.decode(Int.self, forKey: .answerCount)
        title = try container.decode(String.self, forKey: .title)
        isAnswered = try container.decode(Bool.self, forKey: .isAnswered)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        body = try container.decode(String.self, forKey: .body)
        answers = try container.decode([Answer].self, forKey: .answers)
        do {
            owner = try container.decodeIfPresent(User.self, forKey: .owner)
        } catch User.DecodingError.userDoesNotExist {
            owner = nil
        }
    }
}

extension Question {
    struct Wrapper: Decodable {
        let items: [Question]

        enum CodingKeys: String, CodingKey {
            case items
        }
    }
}


extension [Question] {
    static var preview: [Question] {
        let url = Bundle.main.url(forResource: "questions", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let wrapper = try! decoder.decode(Question.Wrapper.self, from: data)
        return wrapper.items
    }
}

extension Question {
    static var preview: Question {
        [Question].preview[0]
    }

    static var unanswered: Question {
        Question(
            isAnswered: false,
            id: Question.preview.id,
            viewCount: Question.preview.viewCount,
            answerCount: Question.preview.answerCount,
            title: Question.preview.title,
            body: Question.preview.body,
            creationDate: Question.preview.creationDate,
            owner: Question.preview.owner,
            score: Question.preview.score,
            answers: Question.preview.answers)
    }
}
