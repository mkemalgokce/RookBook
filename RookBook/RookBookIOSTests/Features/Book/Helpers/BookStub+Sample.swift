// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

extension BookStub {
    static func bookWithContent() -> [BookStub] {
        [
            BookStub(
                name: "The Great Gatsby",
                description: """
                In this novel, F. Scott Fitzgerald delves into themes of wealth, social standing, and
                the elusive nature of the American Dream. The story is set in the 1920s, a period known
                for its excesses, and centers around the enigmatic millionaire Jay Gatsby, his
                unrequited love for Daisy Buchanan, and the moral decay of society.
                """,
                author: "F. Scott Fitzgerald",
                image: UIImage.make(withColor: .red)
            ),
            BookStub(
                name: "To Kill a Mockingbird",
                description: """
                Harper Lee's classic novel explores racial injustice in the Deep South through the eyes
                of young Scout Finch. Set in the 1930s, the novel addresses themes of prejudice, moral
                courage, and empathy, as Scout's father, lawyer Atticus Finch, defends a black man
                falsely accused of raping a white woman.
                """,
                author: "Harper Lee",
                image: UIImage.make(withColor: .green)
            ),
            BookStub(
                name: "1984",
                description: """
                George Orwell's dystopian masterpiece presents a chilling vision of a totalitarian
                society under constant surveillance. The novel follows Winston Smith, who secretly
                defies the omnipresent Party in his search for truth and individual freedom. Orwell's
                portrayal of propaganda, censorship, and the erosion of civil liberties remains
                strikingly relevant today.
                """,
                author: "George Orwell",
                image: UIImage.make(withColor: .yellow)
            )
        ]
    }

    static func bookWithFailedImageLoading() -> [BookStub] {
        [
            BookStub(
                name: "The Great Gatsby",
                description: """
                In this novel, F. Scott Fitzgerald delves into themes of wealth, social standing,
                and the elusive nature of the American Dream. The story is set in the 1920s, a period known
                for its excesses, and centers around the enigmatic millionaire Jay Gatsby, his
                unrequited love for Daisy Buchanan, and the moral decay of society.
                """,
                author: "F. Scott Fitzgerald",
                image: nil
            ),
            BookStub(
                name: "To Kill a Mockingbird",
                description: """
                Harper Lee's classic novel explores racial injustice in the Deep South through the eyes
                of young Scout Finch. Set in the 1930s, the novel addresses themes of prejudice, moral
                courage, and empathy, as Scout's father, lawyer Atticus Finch, defends a black man
                 falsely accused of raping a white woman.
                """,
                author: "Harper Lee",
                image: nil
            ),
            BookStub(
                name: "1984",
                description: """
                George Orwell's dystopian masterpiece presents a chilling vision of a totalitarian
                society under constant surveillance. The novel follows Winston Smith, who secretly
                defies the omnipresent Party in his search for truth and individual freedom. Orwell's
                portrayal of propaganda, censorship, and the erosion of civil liberties remains
                strikingly relevant today.
                """,
                author: "George Orwell",
                image: nil
            )
        ]
    }
}
