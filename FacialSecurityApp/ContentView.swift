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
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray4)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack(spacing: 30) {
                    Text("Facial Security App")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 50)

                    NavigationLink(destination: RegisterView()) {
                        Text("Registrar Usuario")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: RecognizeView()) {
                        Text("Reconocer Rostro")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: UserListView()) {
                        Text("Listar Usuarios")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
        }
    }
}
