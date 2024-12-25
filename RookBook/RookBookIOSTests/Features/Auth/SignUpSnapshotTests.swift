// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookIOS
@testable import SnapShooter
import XCTest

final class SignUpSnapshotTests: XCTestCase {
    func test_signUp_emptyState_light() {
        let (_, nc) = makeSUT()
        let image = nc.snapshot(for: .iPhone13(style: .light))

        assert(image)
    }

    func test_signUp_filledState_dark() {
        let (sut, nc) = makeSUT()
        fillFields(on: sut)

        let image = nc.snapshot(for: .iPhone13(style: .dark))

        assert(image)
    }

    // MARK: - Helpers
    private func makeSUT() -> (SignUpViewController, UINavigationController) {
        let sut = SignUpViewController()
        let nc = NavigationController(rootViewController: sut)
        sut.title = "Sign Up"
        return (sut, nc)
    }

    private func fillFields(on sut: SignUpViewController) {
        sut.fullNameText = "Test Name"
        sut.mailText = "any@mail.com"
        sut.passwordText = "password"
    }
}
