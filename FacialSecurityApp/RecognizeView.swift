//
//  RecognizeView.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/21/25.
//

import SwiftUI

struct RecognizeView: View {
    @State private var image = UIImage()
    @State private var showImagePicker = false
    @State private var resultMessage = ""
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showActionSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
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

            Button("Reconocer Rostro") {
                APIService.shared.recognizeFace(image: image) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            if response.contains("\"match\": false") {
                                alertMessage = "Rostro no detectado"
                            } else {
                                if let data = response.data(using: .utf8),
                                   let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                                   let user = dict["user"] as? [String: Any] {
                                    let nombre = user["nombre"] as? String ?? ""
                                    let apellido = user["apellido"] as? String ?? ""
                                    let codigo = user["codigo_unico"] as? String ?? ""
                                    let req = (user["requisitoriado"] as? Bool == true) ? "🚨 ¡Requisitoriado!" : "No requisitoriado"
                                    alertMessage = "Detectado: \(nombre) \(apellido)\nCódigo: \(codigo)\nEstado: \(req)"
                                } else {
                                    alertMessage = "Respuesta no válida del servidor."
                                }
                            }
                        case .failure(let error):
                            alertMessage = "Error: \(error.localizedDescription)"
                        }
                        showAlert = true
                    }
                }
            }
            Text(resultMessage)
                .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: self.sourceType, selectedImage: $image)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Resultado"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
