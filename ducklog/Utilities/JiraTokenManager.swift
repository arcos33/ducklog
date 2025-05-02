//
//  JiraTokenManager.swift
//  ducklog
//
//  Created by Joal.Arcos on 5/2/25.
//

import KeychainAccess

struct JiraTokenManager {
    private static let keychain = Keychain(service: "dev.ducklog.mac")
    private static let key = "jiraAPIToken"

    static func save(token: String) {
        try? keychain.set(token, key: key)
    }

    static func getToken() -> String? {
        return try? keychain.get(key)
    }

    static func deleteToken() {
        try? keychain.remove(key)
    }
}
