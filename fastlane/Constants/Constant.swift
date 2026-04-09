//
//  Constant.swift
//  FastlaneRunner
//
//  Created by Su Ho on 22/09/2022.
//  Copyright © 2022 Nimble. All rights reserved.
//

import Foundation

enum Constant {

    // MARK: - App Store

    static let testFlightTesterGroups: [String] = []

    // MARK: - Firebase

    static let devFirebaseAppId = "1:663051039370:ios:41cc053ccc1c39f8d5f373"
    static let stagingFirebaseAppId = "1:663051039370:ios:41cc053ccc1c39f8d5f373"
    static let productionFirebaseAppId = "1:663051039370:ios:41cc053ccc1c39f8d5f373"
    static let firebaseTesterGroups = ""

    // MARK: - Match

    static let appleDevUserName = ""
    static let appleDevTeamId = "4TWS7E2EPE"
    static let appleStagingUserName = ""
    static let appleStagingTeamId = "4TWS7E2EPE"
    static let appleProductionUserName = ""
    static let appleProductionTeamId = "4TWS7E2EPE"
    static let keychainName = "iOSTemplate_keychain"
    static let matchURL = "git@github.com:nimblehq/match-certificates.git"
    static let apiKey: [String: Any] = {
        var key = Secret.appstoreConnectAPIKey
        if let data = Data(base64Encoded: Secret.appstoreConnectAPIKey),
           let decodedKey = String(data: data, encoding: .utf8) {
            key = decodedKey
        }

        return [
            "key_id" : Secret.appStoreKeyIdKey,
            "issuer_id": Secret.appStoreIssuerIdKey,
            "key": key,
            "in_house": false
        ]
    }()

    // MARK: - Path

    static let outputPath = "./Output"
    static let buildPath = "\(outputPath)/Build"
    static let derivedDataPath = "\(outputPath)/DerivedData"
    static let projectPath: String = "./\(projectName).xcodeproj"
    static let testOutputDirectoryPath = "./fastlane/test_output"
    static let infoPlistPath = "\(projectName)/Configurations/Plists/Info.plist"

    // MARK: Platform

    static var platform: PlatformType {
        if EnvironmentParser.bool(key: "CM_BRANCH") {
            return .codeMagic
        } else if EnvironmentParser.bool(key: "BITRISE_IO") {
            return .bitrise
        } else if EnvironmentParser.bool(key: "GITHUB_ACTIONS") {
            return .gitHubActions
        }
        return .unknown
    }

    static var releaseNote: String {
        EnvironmentParser.string(key: "RELEASE_NOTES")
    }

    // MARK: - Project

    static let devBundleId = "co.nimblehq.ios.templates.dev"
    static let stagingBundleId = "co.nimblehq.ios.templates.staging"
    static let productionBundleId = "co.nimblehq.ios.templates"
    static let projectName = "iOSTemplate"

    // MARK: - Symbol

    // Suffix for archived dSYM zip files used in Constant.Environment.dsymPath.
    static let dSYMSuffix: String = ".dSYM.zip"

    // MARK: - Build and Version

    static let manualVersion: String = ""

    // MARK: - Device

    static let devices = ["iPhone 15 Pro"]
}

extension Constant {

    enum Environment: String {

        case dev = "Dev"
        case staging = "Staging"
        case production = "Production"

        var productName: String { "\(Constant.projectName) \(rawValue)".trimmed }

        var scheme: String {
            switch self {
            case .dev, .staging: return "\(Constant.projectName) \(rawValue)".trimmed
            case .production: return Constant.projectName.trimmed
            }
        }

        var bundleId: String {
            switch self {
            case .dev: return Constant.devBundleId
            case .staging: return Constant.stagingBundleId
            case .production: return Constant.productionBundleId
            }
        }

        var firebaseAppId: String {
            switch self {
            case .dev: return Constant.devFirebaseAppId
            case .staging: return Constant.stagingFirebaseAppId
            case .production: return Constant.productionFirebaseAppId
            }
        }

        var gspPath: String {
            let infoName = "GoogleService-Info.plist"
            let googleServiceFolder = "./\(Constant.projectName)/Configurations/Plists/GoogleService"
            switch self {
            case .dev: return "\(googleServiceFolder)/Dev/\(infoName)"
            case .staging: return "\(googleServiceFolder)/Staging/\(infoName)"
            case .production: return "\(googleServiceFolder)/Production/\(infoName)"
            }
        }

        var dsymPath: String {
            let outputDirectoryURL = URL(fileURLWithPath: Constant.outputPath)
            return outputDirectoryURL.appendingPathComponent(productName + ".app" + Constant.dSYMSuffix).relativePath
        }

        var appleUsername: String {
            switch self {
            case .dev: return Constant.appleDevUserName
            case .staging: return Constant.appleStagingUserName
            case .production: return Constant.appleProductionUserName
            }
        }

        var appleTeamId: String {
            switch self {
            case .dev: return Constant.appleDevTeamId
            case .staging: return Constant.appleStagingTeamId
            case .production: return Constant.appleProductionTeamId
            }
        }
    }

    enum BuildType: String {

        case development
        case adHoc = "ad-hoc"
        case appStore = "app-store"

        var value: String { return rawValue }

        var match: String {
            switch self {
            case .development: return "development"
            case .adHoc: return "adhoc"
            case .appStore: return "appstore"
            }
        }

        var configuration: String {
            switch self {
            case .development: return "Debug"
            case .adHoc, .appStore: return "Release"
            }
        }

        var codeSignIdentity: String {
            switch self {
            case .development: return "iPhone Developer"
            case .adHoc, .appStore: return "iPhone Distribution"
            }
        }

        var method: String {
            switch self {
            case .development: return "Development"
            case .adHoc: return "AdHoc"
            case .appStore: return "AppStore"
            }
        }
    }

    enum PlatformType {

        case gitHubActions, bitrise, codeMagic, unknown
    }
}

extension String {

    fileprivate var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
