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
    @State private var imageFront = UIImage()
    @State private var imageLeft = UIImage()
    @State private var imageRight = UIImage()
    @State private var captureStep = 0 // 0: Frontal, 1: Izquierda, 2: Derecha
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

            Button(captureStepTitle()) {
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
            Image(uiImage: imageFront)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            Image(uiImage: imageLeft)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            Image(uiImage: imageRight)
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            Button("Siguiente Imagen") {
                if captureStep < 2 {
                    captureStep += 1
                }
            }
            .disabled(getCurrentImage().wrappedValue.cgImage == nil)

            Button("Registrar Usuario") {
                guard imageFront.cgImage != nil, imageLeft.cgImage != nil, imageRight.cgImage != nil else {
                    alertMessage = "Debes capturar las tres imágenes."
                    showAlert = true
                    return
                }

                let user = User(id: 0, nombre: nombre, apellido: apellido,
                                codigo_unico: codigoUnico, email: email,
                                requisitoriado: requisitoriado)
                APIService.shared.registerUser(user: user, imageFront: imageFront, imageLeft: imageLeft, imageRight: imageRight) { result in
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
            ImagePicker(sourceType: self.sourceType, selectedImage: getCurrentImage())
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Resultado"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func captureStepTitle() -> String {
        switch captureStep {
        case 0: return "Seleccionar Imagen Frontal"
        case 1: return "Seleccionar Imagen Izquierda"
        case 2: return "Seleccionar Imagen Derecha"
        default: return "Captura completada"
        }
    }

    func getCurrentImage() -> Binding<UIImage> {
        switch captureStep {
        case 0: return $imageFront
        case 1: return $imageLeft
        case 2: return $imageRight
        default: return $imageFront
        }
    }
}
