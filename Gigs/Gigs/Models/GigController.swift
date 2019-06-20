//
//  GigController.swift
//  Gigs
//
//  Created by Sean Acres on 6/19/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case noEncode
}

class GigController {
    var bearer: Bearer?
    var gigs: [Gig] = []
    private let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func loginWith(user: User, loginType: LoginType, completion: @escaping (Error?) -> ()) {
        let requestURL = baseURL.appendingPathComponent("users/\(loginType.rawValue)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("error encoding: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            if loginType == .signIn {
                guard let data = data else {
                    completion(NSError())
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
                    completion(nil)
                } catch {
                    print("error decoding data/token: \(error)")
                    completion(error)
                    return
                }
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchGigs(completion: @escaping (NetworkError?) -> ()) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let gigsURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: gigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            if let _ = error {
                completion(.otherError)
                return
            }
            
            guard let data = data else {
                completion(.badData)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                self.gigs = try jsonDecoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                completion(.noDecode)
            }
            }.resume()
    }
    
    func addGig(with gig: Gig, completion: @escaping(NetworkError?) -> ()) {
        guard let bearer = bearer else {
            completion(.noAuth)
            return
        }
        
        let gigsURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: gigsURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        do {
            request.httpBody = try jsonEncoder.encode(gig)
        } catch {
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.badAuth)
                return
            }
            
            if let _ = error {
                completion(.otherError)
                return
            }
            
            self.gigs.append(gig)
            completion(nil)
            }.resume()
    }
}
