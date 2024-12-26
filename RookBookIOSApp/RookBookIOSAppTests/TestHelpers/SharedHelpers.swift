// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import RookBookCore

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}

var onboardingTitle: String {
    OnboardingPresenter.title
}
