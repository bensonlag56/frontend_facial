//
//  UserModel.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/20/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let nombre: String
    let apellido: String
    let codigo_unico: String
    let email: String
    let requisitoriado: Bool
}

struct FaceMatchResult: Codable {
    let match: Bool
    let user: User?
    let all_matches: [User]?
}
