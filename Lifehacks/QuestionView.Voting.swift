//
//  QuestionView.Voting.swift
//  Lifehacks
//
//  Created by Marcel Mravec on 18.10.2023.
//

import SwiftUI

extension QuestionView {
    struct Voting: View {
        let score: Int
        let vote: Vote?
        let upvote: () -> Void
        let downvote: () -> Void
        let unvote: () -> Void

        enum Vote {
            case up, down
        }

        var body: some View {
            VStack(spacing: 8.0) {
                VoteButton(buttonType: .up, highlighted: vote == .up) {
                    cast(vote: .up)
                }
                Text("\(score)")
                    .font(.title)
                    .foregroundColor(.secondary)
                VoteButton(buttonType: .down, highlighted: vote == .down) {
                    cast(vote: .down)
                }
            }
            .frame(minWidth: 56.0)
        }

        private func cast(vote: Vote) {
            switch (self.vote, vote) {
                case (nil, .up), (.down, .up): upvote()
                case (nil, .down), (.up, .down): downvote()
                default: unvote()
            }
        }
    }
}


//MARK: - VoteButton

extension QuestionView.Voting {
    struct VoteButton: View {
        let buttonType: ButtonType
        let highlighted: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                buttonType.image(highlighted: highlighted)
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        }
    }
}

extension QuestionView.Voting.VoteButton {
    enum ButtonType: String {
        case up = "arrowtriangle.up"
        case down = "arrowtriangle.down"
        
        func image(highlighted: Bool) -> Image {
            let imageName = rawValue + (highlighted ? ".fill" : "")
            return Image(systemName: imageName)
        }
    }
}

extension QuestionView.Voting.Vote {
    init?(vote: Vote?) {
        switch vote {
            case .up: self = .up
            case .down: self = .down
            case .none: return nil
        }
    }
}

struct QuestionView_Voting_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 16) {
            QuestionView.Voting.VoteButton(buttonType: .up, highlighted: true, action: {})
            QuestionView.Voting.VoteButton(buttonType: .up, highlighted: false, action: {})
            QuestionView.Voting.VoteButton(buttonType: .down, highlighted: true, action: {})
            QuestionView.Voting.VoteButton(buttonType: .down, highlighted: false, action: {})
        }
        .previewLayout(.sizeThatFits)
    }
}
