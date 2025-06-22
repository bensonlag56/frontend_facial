//
//  RegisterView.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/21/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var nombre = ""
    @State private var apellido = ""
    @State private var codigoUnico = ""
    @State private var email = ""
    @State private var requisitoriado = false
    @State private var image = UIImage()
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showActionSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            TextField("Nombre", text: $nombre)
            TextField("Apellido", text: $apellido)
            TextField("Código Único", text: $codigoUnico)
            TextField("Email", text: $email)
            Toggle("Requisitoriado", isOn: $requisitoriado)

            Button("Seleccionar Imagen") {
                showActionSheet = true
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Seleccionar fuente"), buttons: [
                    .default(Text("Cámara")) {
                        self.sourceType = .camera
                        self.showImagePicker = true
                    },
                    .default(Text("Galería")) {
                        self.sourceType = .photoLibrary
                        self.showImagePicker = true
                    },
                    .cancel()
                ])
            }
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            Button("Registrar Usuario") {
                let user = User(id: 0, nombre: nombre, apellido: apellido,
                                codigo_unico: codigoUnico, email: email,
                                requisitoriado: requisitoriado)
                APIService.shared.registerUser(user: user, image: image) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            alertMessage = "Usuario registrado exitosamente"
                        case .failure(let error):
                            alertMessage = "Error: \(error.localizedDescription)"
                        }
                        showAlert = true
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: self.sourceType, selectedImage: $image)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Resultado"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
