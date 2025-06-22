//
//  User.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/21/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: Int
    let nombre: String
    let apellido: String
    let codigo_unico: String
    let email: String
    let requisitoriado: Bool
}
