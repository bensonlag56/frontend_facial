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
            Section(header: Text("Datos del Usuario").font(.headline)) {
                TextField("Nombre", text: $nombre)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Apellido", text: $apellido)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Código Único", text: $codigoUnico)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Toggle("Requisitoriado", isOn: $requisitoriado)
            }

            Section(header: Text("Captura de Imágenes").font(.headline)) {
                Button(captureStepTitle()) {
                    showActionSheet = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            HStack(spacing: 10) {
                Image(uiImage: imageFront)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .shadow(radius: 4)

                Image(uiImage: imageLeft)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .shadow(radius: 4)

                Image(uiImage: imageRight)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            }
            .padding(.vertical)

            Button("Siguiente Imagen") {
                if captureStep < 2 {
                    captureStep += 1
                }
            }
            .disabled(getCurrentImage().wrappedValue.cgImage == nil)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

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
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: self.sourceType, selectedImage: getCurrentImage())
        }
        .sheet(isPresented: $showActionSheet) {
            SourceTypeSelectionView(show: $showActionSheet, sourceType: $sourceType, showImagePicker: $showImagePicker)
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

private struct SourceTypeSelectionView: View {
    @Binding var show: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var showImagePicker: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Selecciona una fuente")
                .font(.headline)
            Button("Cámara") {
                self.sourceType = .camera
                self.showImagePicker = true
                self.show = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Galería") {
                self.sourceType = .photoLibrary
                self.showImagePicker = true
                self.show = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Cancelar") {
                self.show = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
