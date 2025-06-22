//
//  APIService.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/21/25.
//

import Foundation
import UIKit

class APIService {
    static let shared = APIService()
    let baseURL = "http://127.0.0.1:5001" // Cambia a tu IP local o Railway

    func registerUser(user: User, imageFront: UIImage, imageLeft: UIImage, imageRight: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageFrontData = imageFront.jpegData(compressionQuality: 0.8)?.base64EncodedString(),
              let imageLeftData = imageLeft.jpegData(compressionQuality: 0.8)?.base64EncodedString(),
              let imageRightData = imageRight.jpegData(compressionQuality: 0.8)?.base64EncodedString() else { return }

        let parameters: [String: Any] = [
            "nombre": user.nombre,
            "apellido": user.apellido,
            "codigo_unico": user.codigo_unico,
            "email": user.email,
            "requisitoriado": user.requisitoriado,
            "imagen_frontal": imageFrontData,
            "imagen_izquierda": imageLeftData,
            "imagen_derecha": imageRightData
        ]

        guard let url = URL(string: "\(baseURL)/register") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let responseStr = String(data: data, encoding: .utf8) {
                completion(.success(responseStr))
            }
        }.resume()
    }

    func recognizeFace(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString() else { return }

        let parameters: [String: Any] = ["imagen": imageData]

        guard let url = URL(string: "\(baseURL)/recognize") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let responseStr = String(data: data, encoding: .utf8) {
                completion(.success(responseStr))
            }
        }.resume()
    }
}
