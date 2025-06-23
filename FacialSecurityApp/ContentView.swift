//
//  ContentView.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Facial Security App")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 50)

                NavigationLink("Registrar Usuario", destination: RegisterView())
                    .buttonStyle(.borderedProminent)
                    .font(.title2)

                NavigationLink("Reconocer Rostro", destination: RecognizeView())
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
                
                NavigationLink("Listar Usuarios", destination: UserListView())
                    .buttonStyle(.borderedProminent)
                    .font(.title2)

                Spacer()
            }
            .padding()
        }
    }
}
