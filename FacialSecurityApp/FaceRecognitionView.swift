//
//  FaceRecognitionView.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/20/25.
//

import SwiftUI

struct FaceRecognitionView: View {
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var matchResult: FaceMatchResult?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            if let inputImage = inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }
            
            HStack {
                Button("Tomar Foto") {
                    showingCamera = true
                }
                .padding()
                
                Button("Seleccionar Imagen") {
                    showingImagePicker = true
                }
                .padding()
            }
            
            Button("Comparar Rostro") {
                compareFace()
            }
            .padding()
            .disabled(inputImage == nil)
            
            if let result = matchResult {
                if result.match {
                    VStack(alignment: .leading) {
                        Text("Coincidencia encontrada").font(.headline)
                        if let user = result.user {
                            Text("Nombre: \(user.nombre) \(user.apellido)")
                            Text("Código: \(user.codigo_unico)")
                            Text("Email: \(user.email)")
                            
                            if user.requisitoriado {
                                Text("¡ALERTA! USUARIO REQUISITORIADO")
                                    .foregroundColor(.red)
                                    .font(.headline)
                                    .onAppear {
                                        // Simular alerta sonora y visual
                                        
                                        // Aquí podrías agregar más efectos de alerta
                                    }
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("No se encontraron coincidencias").padding()
                }
            }
            
            Spacer()
        }
        .navigationTitle("Reconocimiento Facial")
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
    
    func compareFace() {
        guard let image = inputImage else { return }
        
        NetworkService.shared.recognizeFace(image: image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    matchResult = result
                    if let user = result.user, user.requisitoriado {
                        alertMessage = "¡ALERTA DE SEGURIDAD! Usuario Requisitoriado Detectado. Notificación Enviada a la Policía (Simulada)"
                        showingAlert = true
                    }
                case .failure(let error):
                    alertMessage = "Error: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
}

#Preview {
    FaceRecognitionView()
}
