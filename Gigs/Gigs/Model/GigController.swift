//
//  GigController.swift
//  Gigs
//
//  Created by Sean Acres on 7/10/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

class GigController {
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum LoginType: String {
        case signUp = "signup"
        case logIn = "login"
    }
    
    var bearer: Bearer?
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func loginWith(with user: User, loginType: LoginType, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent(loginType.rawValue)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("error encoding user: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                NSLog("Error on request for \(loginType): \(error)")
                completion(error)
                return
            }
            
            if loginType == .logIn {
                guard let data = data else {
                    NSLog("No data returned from login")
                    completion(error)
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
                    completion(nil)
                } catch {
                    print("error decoding token on login: \(error)")
                    completion(error)
                    return
                }
            }
            
            completion(nil)
            }.resume()
    }
}
