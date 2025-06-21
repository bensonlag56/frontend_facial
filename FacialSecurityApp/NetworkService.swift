//
//  NetworkService.swift
//  FacialSecurityApp
//
//  Created by Benson Hilario on 6/20/25.
//

import UIKit

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "http://127.0.0.1:5001"
    
    func registerUser(nombre: String, apellido: String, codigo: String, email: String, requisitoriado: Bool, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al procesar imagen"])))
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        let userData: [String: Any] = [
            "nombre": nombre,
            "apellido": apellido,
            "codigo_unico": codigo,
            "email": email,
            "requisitoriado": requisitoriado,
            "imagen_facial": base64Image
        ]
        
        guard let url = URL(string: "\(baseURL)/register") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userData)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    completion(.success(responseString))
                }
            }
        }.resume()
    }
    
    func recognizeFace(image: UIImage, completion: @escaping (Result<FaceMatchResult, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al procesar imagen"])))
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        let requestData: [String: Any] = ["imagen": base64Image]
        
        guard let url = URL(string: "\(baseURL)/recognize") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(FaceMatchResult.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    completion(.success(users))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func deleteUser(id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            }
        }.resume()
    }
}
