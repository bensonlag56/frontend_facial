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
        NavigationView {
            VStack {
                TextField("Buscar por nombre...", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                HStack {
                    Button("Buscar") {
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
                    }
                    .padding()

                    Button("Listar Todos") {
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
                    }
                    .padding()
                }

                List {
                    ForEach(users, id: \.id) { user in
                        NavigationLink(destination: EditUserView(user: user)) {
                            VStack(alignment: .leading) {
                                Text("\(user.nombre) \(user.apellido)").font(.headline)
                                Text("Código: \(user.codigo_unico)").font(.subheadline)
                                Text("Requisitoriado: \(user.requisitoriado ? "Sí" : "No")").font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: deleteUser)
                }
            }
            .navigationTitle("Usuarios Registrados")
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
            TextField("Nombre", text: $user.nombre)
            TextField("Apellido", text: $user.apellido)
            TextField("Código Único", text: $user.codigo_unico)
            TextField("Email", text: $user.email)
            Toggle("Requisitoriado", isOn: $user.requisitoriado)

            Button("Guardar Cambios") {
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
            }
        }
        .navigationTitle("Editar Usuario")
    }
}
