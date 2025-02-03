// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
@testable import SnapShooter
import XCTest

final class SignInUISnapshotTests: XCTestCase {
    func test_signIn_emptyState_light() {
        let (_, nc) = makeSUT()
        let image = nc.snapshot(for: .iPhone13(style: .light))

        assert(image)
    }

    func test_signIn_filledState_dark() {
        let (sut, nc) = makeSUT()
        fillFields(on: sut)
        let image = nc.snapshot(for: .iPhone13(style: .dark))

        assert(image)
    }

    // MARK: - Helpers
    private func makeSUT() -> (SignInViewController, UINavigationController) {
        let sut = SignInViewController()
        let nc = NavigationController(rootViewController: sut)
        sut.title = "Welcome Back"
        return (sut, nc)
    }

    private func fillFields(on sut: SignInViewController) {
        sut.mailText = "any@mail.com"
        sut.passwordText = "password"
    }
}
