//
//  UserListView.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/20/25.
//

import SwiftUI

struct UserListView: View {
    @State private var users: [User] = []
    @State private var searchText = ""
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter {
                $0.nombre.localizedCaseInsensitiveContains(searchText) ||
                $0.apellido.localizedCaseInsensitiveContains(searchText) ||
                $0.codigo_unico.localizedCaseInsensitiveContains(searchText) ||
                $0.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredUsers) { user in
                VStack(alignment: .leading) {
                    Text("\(user.nombre) \(user.apellido)")
                        .font(.headline)
                    Text(user.codigo_unico)
                    Text(user.email)
                    if user.requisitoriado {
                        Text("REQUISITORIADO")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }
                }
            }
            .onDelete(perform: deleteUser)
        }
        .searchable(text: $searchText)
        .navigationTitle("Usuarios Registrados")
        .toolbar {
            EditButton()
        }
        .onAppear {
            loadUsers()
        }
    }
    
    func loadUsers() {
        NetworkService.shared.fetchUsers { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedUsers):
                    users = fetchedUsers
                case .failure(let error):
                    print("Error loading users: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteUser(at offsets: IndexSet) {
        offsets.forEach { index in
            let user = filteredUsers[index]
            NetworkService.shared.deleteUser(id: user.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        loadUsers() // Recargar la lista después de eliminar
                    case .failure(let error):
                        print("Error deleting user: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
#Preview {
    UserListView()
}
