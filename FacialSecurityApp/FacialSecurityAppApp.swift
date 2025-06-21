//
//  FacialSecurityAppApp.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/20/25.
//

import SwiftUI

@main
struct FacialRecognitionApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    UserRegistrationView()
                }
                .tabItem {
                    Label("Registro", systemImage: "person.badge.plus")
                }
                
                NavigationView {
                    FaceRecognitionView()
                }
                .tabItem {
                    Label("Reconocimiento", systemImage: "faceid")
                }
                
                NavigationView {
                    UserListView()
                }
                .tabItem {
                    Label("Usuarios", systemImage: "list.dash")
                }
            }
        }
    }
}
