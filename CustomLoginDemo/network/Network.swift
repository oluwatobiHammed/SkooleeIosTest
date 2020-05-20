//
//  Network.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation




func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        let decoder = JSONDecoder()
        do {
            let responseObject = try decoder.decode(ResponseType.self, from: data)
            DispatchQueue.main.async {
                completion(responseObject, nil)
            }
        } catch {
            print(error.localizedDescription)
            completion(nil, error)
        }
    }
    task.resume()
    
    return task
}

func getPost(completion: @escaping (Result<[Post], Error> ) -> Void) {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
   _ = taskForGETRequest(url:url, responseType: [Post].self) { response, error in
        if let response = response {
            completion(.success(response))
        } else if let err = error {
            completion(.failure(err))
        }
    }
}
