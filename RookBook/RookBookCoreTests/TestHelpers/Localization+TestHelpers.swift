// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import XCTest

func localized(
    _ key: String,
    table: String,
    bundle: Bundle,
    file: StaticString = #file,
    line: UInt = #line
) -> String {
    let value = bundle.localizedString(forKey: key, value: nil, table: table)
    if value == key {
        XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
    }
    return value
}

func assertLocalizedKeyAndValuesExist(
    in bundle: Bundle,
    _ table: String,
    execute: (Bundle) -> Void,
    file: StaticString = #file,
    line: UInt = #line
) {
    let languages = bundle.localizations
    let defaultLanguage = "en"

    guard languages.contains(defaultLanguage) else {
        XCTFail("Missing default localization for language: \(defaultLanguage)", file: file, line: line)
        return
    }

    languages.forEach { language in
        guard let languageBundle = Bundle(path: bundle.path(forResource: language, ofType: "lproj")!) else {
            XCTFail("Missing bundle for language: \(language)", file: file, line: line)
            return
        }
        execute(languageBundle)
    }
}

func assertLocalizedString(
    _ key: String,
    table: String,
    bundle: Bundle,
    equals expectation: String,
    for language: String,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard let languageBundlePath = bundle.path(forResource: language, ofType: "lproj"),
          let languageBundle = Bundle(path: languageBundlePath) else {
        XCTFail("Missing bundle for language: \(language)", file: file, line: line)
        return
    }

    let value = languageBundle.localizedString(forKey: key, value: nil, table: table)
    XCTAssertEqual(
        value,
        expectation,
        "Expected \(expectation) but got \(value) for key: \(key) in language: \(language)",
        file: file,
        line: line
    )
}

func assertLocalizedStringFormat(
    _ key: String,
    table: String,
    bundle: Bundle,
    matches formatSpecifiers: [String],
    for language: String,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard let languageBundlePath = bundle.path(forResource: language, ofType: "lproj"),
          let languageBundle = Bundle(path: languageBundlePath) else {
        XCTFail("Missing bundle for language: \(language)", file: file, line: line)
        return
    }

    let format = languageBundle.localizedString(forKey: key, value: nil, table: table)

    formatSpecifiers.forEach { specifier in
        XCTAssertTrue(
            format.contains(specifier),
            "Missing format specifier \(specifier) in format string: \(format) for language: \(language)",
            file: file,
            line: line
        )
    }
}

func assertAllLanguagesHaveValue(
    for key: String,
    table: String,
    bundle: Bundle,
    file: StaticString = #file,
    line: UInt = #line
) {
    let languages = bundle.localizations

    languages.forEach { language in
        guard let languageBundlePath = bundle.path(forResource: language, ofType: "lproj"),
              let languageBundle = Bundle(path: languageBundlePath) else {
            XCTFail("Missing bundle for language: \(language)", file: file, line: line)
            return
        }

        let value = languageBundle.localizedString(forKey: key, value: nil, table: table)
        XCTAssertNotEqual(
            value,
            key,
            "Missing translation for key: \(key) in language: \(language)",
            file: file,
            line: line
        )
    }
}

func assertAllLocalizedKeysAndValuesExist(
    in presentationBundle: Bundle,
    _ table: String,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let localizationBundles = allLocalizationBundles(in: presentationBundle, file: file, line: line)
    let localizedStringKeys = allLocalizedStringKeys(in: localizationBundles, table: table, file: file, line: line)

    localizationBundles.forEach { bundle, localization in
        localizedStringKeys.forEach { key in
            let localizedString = bundle.localizedString(forKey: key, value: nil, table: table)

            if localizedString == key {
                let language = Locale.current.localizedString(forLanguageCode: localization) ?? ""

                XCTFail(
                    "Missing \(language) (\(localization)) localized string for key: '\(key)' in table: '\(table)'",
                    file: file,
                    line: line
                )
            }
        }
    }
}

private typealias LocalizedBundle = (bundle: Bundle, localization: String)

private func allLocalizationBundles(in bundle: Bundle, file: StaticString = #filePath,
                                    line: UInt = #line) -> [LocalizedBundle] {
    bundle.localizations.compactMap { localization in
        guard
            let path = bundle.path(forResource: localization, ofType: "lproj"),
            let localizedBundle = Bundle(path: path)
        else {
            XCTFail("Couldn't find bundle for localization: \(localization)", file: file, line: line)
            return nil
        }

        return (localizedBundle, localization)
    }
}

private func allLocalizedStringKeys(
    in bundles: [LocalizedBundle],
    table: String,
    file: StaticString = #filePath,
    line: UInt = #line
) -> Set<String> {
    bundles.reduce([]) { acc, current in
        guard
            let path = current.bundle.path(forResource: table, ofType: "strings"),
            let strings = NSDictionary(contentsOfFile: path),
            let keys = strings.allKeys as? [String]
        else {
            XCTFail("Couldn't load localized strings for localization: \(current.localization)", file: file, line: line)
            return acc
        }

        return acc.union(Set(keys))
    }
}
