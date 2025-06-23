//
//  RecognizeView.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/21/25.
//

import SwiftUI

enum AlertType: Identifiable {
    case resultado(String)
    case requisitoriado
    case notificado

    var id: Int {
        switch self {
        case .resultado: return 0
        case .requisitoriado: return 1
        case .notificado: return 2
        }
    }
}

struct RecognizeView: View {
    @State private var image = UIImage()
    @State private var showImagePicker = false
    @State private var resultMessage = ""
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showActionSheet = false
    @State private var activeAlert: AlertType?

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
                        case .success(let dict):
                            var match = false
                            if let m = dict["match"] as? Bool {
                                match = m
                            } else if let mStr = dict["match"] as? String {
                                match = (mStr == "true")
                            }

                            if match,
                               let user = dict["user"] as? [String: Any] {
                                let nombre = user["nombre"] as? String ?? ""
                                let apellido = user["apellido"] as? String ?? ""
                                let codigo = user["codigo_unico"] as? String ?? ""
                                let requisitoriado = user["requisitoriado"] as? Bool ?? false
                                let reqStatus = requisitoriado ? "🚨 ¡Requisitoriado!" : "No requisitoriado"
                                activeAlert = .resultado("Detectado: \(nombre) \(apellido)\nCódigo: \(codigo)\nEstado: \(reqStatus)")

                                if requisitoriado {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        activeAlert = .requisitoriado
                                    }
                                }
                            } else {
                                activeAlert = .resultado("Rostro no detectado")
                            }
                        case .failure(let error):
                            activeAlert = .resultado("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
            Text(resultMessage)
                .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: self.sourceType, selectedImage: $image)
        }
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .resultado(let mensaje):
                return Alert(title: Text("Resultado"), message: Text(mensaje), dismissButton: .default(Text("OK")))
            case .requisitoriado:
                return Alert(title: Text("Atención"), message: Text("La persona tiene orden de requisitoriado.\nEs posible que nos contactemos con sus autoridades locales."), dismissButton: .default(Text("OK"), action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        activeAlert = .notificado
                    }
                }))
            case .notificado:
                return Alert(title: Text("Notificación Enviada"), message: Text("La información ha sido enviada a las autoridades locales para comenzar con las investigaciones."), dismissButton: .default(Text("OK")))
            }
        }
    }
}
