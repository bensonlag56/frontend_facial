//
//  UserRegistrationView.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/20/25.
//

import SwiftUI

struct UserRegistrationView: View {
    @State private var nombre = ""
    @State private var apellido = ""
    @State private var codigo = ""
    @State private var email = ""
    @State private var requisitoriado = false
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var inputImage: UIImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            Section(header: Text("Información Personal")) {
                TextField("Nombre", text: $nombre)
                TextField("Apellido", text: $apellido)
                TextField("Código Único", text: $codigo)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                Toggle("Requisitoriado", isOn: $requisitoriado)
            }
            
            Section(header: Text("Imagen Facial")) {
                if let inputImage = inputImage {
                    Image(uiImage: inputImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                Button("Tomar Foto") {
                    showingCamera = true
                }
                
                Button("Seleccionar de Galería") {
                    showingImagePicker = true
                }
            }
            
            Section {
                Button("Registrar Usuario") {
                    registerUser()
                }
                .disabled(!formIsValid)
            }
        }
        .navigationTitle("Registro de Usuario")
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(image: $inputImage)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Resultado"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    var formIsValid: Bool {
        !nombre.isEmpty && !apellido.isEmpty && !codigo.isEmpty && isValidEmail(email) && inputImage != nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func registerUser() {
        guard let image = inputImage else { return }
        
        NetworkService.shared.registerUser(
            nombre: nombre,
            apellido: apellido,
            codigo: codigo,
            email: email,
            requisitoriado: requisitoriado,
            image: image
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    alertMessage = message
                    showingAlert = true
                    // Reset form
                    nombre = ""
                    apellido = ""
                    codigo = ""
                    email = ""
                    requisitoriado = false
                    inputImage = nil
                case .failure(let error):
                    alertMessage = "Error: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
}
#Preview {
    UserRegistrationView()
}
