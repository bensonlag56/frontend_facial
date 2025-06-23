//
//  User.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/21/25.
//

import Foundation

struct User: Identifiable, Codable {
    var id: Int
    var nombre: String
    var apellido: String
    var codigo_unico: String
    var email: String
    var requisitoriado: Bool
}
