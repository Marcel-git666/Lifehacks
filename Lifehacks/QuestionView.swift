//
//  QuestionView.swift
//  Lifehacks
//
//  Created by Marcel Mravec on 22.09.2023.
//

import SwiftUI

struct QuestionView: View {
    @State var question: Question
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24.0) {
            HStack(alignment: .top, spacing: 16.0) {
                Voting(score: question.score, 
                       vote: .init(vote: question.vote),
                       upvote: {question.upvote()},
                       downvote: {question.downvote()},
                       unvote: {question.unvote()})
                Info(question: question)
            }
            MarkdownBody(text: question.body)
            if let owner = question.owner {
                Owner(user: owner)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal, 20.0)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuestionView(question: .preview)
            HStack(spacing: 16) {
                QuestionView.Voting.VoteButton(buttonType: .up, highlighted: true, action: {})
                QuestionView.Voting.VoteButton(buttonType: .up, highlighted: false,  action: {})
                QuestionView.Voting.VoteButton(buttonType: .down, highlighted: true,  action: {})
                QuestionView.Voting.VoteButton(buttonType: .down, highlighted: false,  action: {})
            }
            .previewDisplayName("Vote Button")
            .previewLayout(.sizeThatFits)
            QuestionView(question: .preview)
                            .previewDevice(.init(rawValue: "iPhone SE (3rd generation)"))
                            .preferredColorScheme(.dark)
                            .dynamicTypeSize(.xxxLarge)
                            .previewDisplayName("Accessibility")
        }
    }
}

extension QuestionView {
    struct MarkdownBody: View {
        let text: String
        var body: some View {
            let markdown = try! AttributedString(
                markdown: text,
                options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))
            Text(markdown)
                .font(.subheadline)
        }
    }
}


//MARK: - Info

extension QuestionView {
    struct Info: View {
        let title: String
        let viewCount: Int
        let date: Date

        var body: some View {
            VStack(alignment: .leading, spacing: 8.0) {
                Text(title)
                    .font(.headline)
                Group {
                    Text(date: date)
                    Text(viewCount: viewCount)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
    }
}

//MARK: - OwnerView

extension QuestionView {
    struct Owner: View {
        let name: String
        let reputation: Int
        let profileImageURL: URL?

        var body: some View {
            HStack {
                AsyncImage(url: profileImageURL) { image in
                    image
                        .circular()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 48.0, height: 48.0)
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(name)
                        .font(.headline)
                    Text("\(reputation.formatted()) reputation")
                        .font(.caption)
                }
            }
            .padding(16)
            .style(color: .accentColor)
        }
    }
}

extension QuestionView.Info {
    init(question: Question) {
        title = question.title
        viewCount = question.viewCount
        date = question.creationDate
    }
}

extension QuestionView.Owner {
    init(user: User) {
        name = user.name
        reputation = user.reputation
        profileImageURL = user.profileImageURL
    }
}

//MARK: - Image extension

extension Image {
    func circular(borderColor: Color = .white) -> some View{
        self
            .resizable()
            .clipShape(Circle())
            .overlay(Circle()
                .stroke(borderColor, lineWidth: 2))
    }
}

struct Image_Previews: PreviewProvider {
    static var previews: some View {
        Image("avatar")
            .circular(borderColor: .accentColor)
            .frame(width: 200.0, height: 200.0)
    }
}

struct Style: ViewModifier {
    let color: Color
    var isFilled = true
    var isRounded = true

    func body(content: Content) -> some View {
        let radius = isRounded ? 10.0 : 0.0
        if isFilled {
            content
                .background(color)
                .cornerRadius(radius)
                .foregroundColor(.white)
        } else {
            content
                .background(
                    RoundedRectangle(cornerRadius: radius)
                        .strokeBorder(color, lineWidth: 2.0)
                )
        }
    }
}


struct Style_Previews: PreviewProvider {
    static var previews: some View {
        let size = 100.0
        Grid {
            GridRow {
                Text("Accent")
                    .frame(width: size, height: size)
                    .style(color: .accentColor, isRounded: false)
                Text("Pizazz")
                    .frame(width: size, height: size)
                    .style(color: .pizazz)
                Text("Pizazz")
                    .frame(width: size, height: size)
                    .style(color: .pizazz, isFilled: false)
            }
            GridRow {
                Text("Electric Violet")
                    .frame(width: size, height: size)
                    .style(color: .electricViolet, isRounded: false)
                Text("Blaze Orange")
                    .frame(width: size, height: size)
                    .style(color: .blazeOrange)
                Text("Blaze Orange")
                    .frame(width: size, height: size)
                    .style(color: .blazeOrange, isFilled: false)
            }
        }
    }
}
