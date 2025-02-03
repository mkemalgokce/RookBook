// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL(withKey key: String = "any") -> URL {
    URL(string: "http://\(key)-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}

func makeBook(id: UUID = UUID(),
              title: String = "any title",
              description: String = "any description",
              author: String = "any author",
              image: URL = anyURL()) -> Book {
    Book(
        id: id,
        title: title,
        description: description,
        author: author,
        currentPage: 0,
        numberOfPages: 42,
        coverImage: image,
        lastReadAt: Date(),
        isFavorite: false
    )
}

func makeAuthenticatedUser(
    id: String = UUID().uuidString,
    email: String = "any@mail.com",
    name: String = "Any Name"
) -> AuthenticatedUser {
    AuthenticatedUser(id: id, email: email, name: name)
}

func makeAppleCredentials() -> AppleCredentials {
    AppleCredentials(
        userIdentifier: "any",
        email: "any@mail.com",
        fullName: "any name",
        authorizationCode: anyData(),
        identityToken: anyData()
    )
}

var onboardingTitle: String {
    OnboardingPresenter.title
}

var bookListTitle: String {
    BookListPresenter.title
}

enum SignIn {
    static var title: String { SignInPresenter.title }
    static var emailPlaceholder: String { SignInPresenter.emailPlaceholder }
    static var passwordPlaceholder: String { SignInPresenter.passwordPlaceholder }
    static var signInButtonTitle: String { SignInPresenter.signInButtonTitle }
    static var signInWithAppleButtonTitle: String { SignInPresenter.signInWithAppleButtonTitle }
    static var signUpButtonTitle: String {
        SignInPresenter.dontHaveAnAccountTitle + " " + SignInPresenter.signUpButtonTitle
    }
}
