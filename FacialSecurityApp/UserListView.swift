//
//  UserListView.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/22/25.
//

import SwiftUI

struct UserListView: View {
    @State private var users: [User] = []
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Buscar por nombre...", text: $searchText)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)

                HStack(spacing: 12) {
                    Button(action: {
                        APIService.shared.fetchUsers(nombre: searchText) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let fetchedUsers):
                                    users = fetchedUsers
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                    }) {
                        Text("Buscar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        APIService.shared.fetchUsers(nombre: nil) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let fetchedUsers):
                                    users = fetchedUsers
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                    }) {
                        Text("Listar Todos")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                List {
                    ForEach(users, id: \.id) { user in
                        NavigationLink(destination: EditUserView(user: user)) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(user.nombre) \(user.apellido)")
                                        .font(.headline)
                                    Spacer()
                                    if user.requisitoriado {
                                        Text("⚠️")
                                            .font(.headline)
                                            .foregroundColor(.red)
                                    }
                                }
                                Text("Código: \(user.codigo_unico)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Requisitoriado: \(user.requisitoriado ? "Sí" : "No")")
                                    .font(.subheadline)
                                    .foregroundColor(user.requisitoriado ? .red : .green)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                            )
                        }
                    }
                    .onDelete(perform: deleteUser)
                }
                .listStyle(PlainListStyle())
                .padding(.top, 8)
            }
            .navigationTitle("👥 Usuarios Registrados")
        }
    }
    func deleteUser(at offsets: IndexSet) {
        offsets.forEach { index in
            let user = users[index]
            APIService.shared.deleteUser(id: user.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        users.remove(at: index)
                    case .failure(let error):
                        print("Error deleting user: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

// MARK: - EditUserView
struct EditUserView: View {
    @State var user: User
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Datos Personales")) {
                TextField("Nombre", text: $user.nombre)
                TextField("Apellido", text: $user.apellido)
                TextField("Código Único", text: $user.codigo_unico)
                TextField("Email", text: $user.email)
            }

            Section(header: Text("Estado")) {
                Toggle("Requisitoriado", isOn: $user.requisitoriado)
            }

            Section {
                Button(action: {
                    APIService.shared.updateUser(user: user) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                presentationMode.wrappedValue.dismiss()
                            case .failure(let error):
                                print("Error updating user: \(error.localizedDescription)")
                            }
                        }
                    }
                }) {
                    Text("Guardar Cambios")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationBarTitle("Editar Usuario", displayMode: .inline)
    }
}
