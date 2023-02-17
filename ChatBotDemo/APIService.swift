//
//  APIService.swift
//  Dall-E 2
//
//  Created by YouTube on 12/30/22.
//

import UIKit



enum APIError: Error {
    case unableToCreateImageURL
    case unableToConvertDataIntoImage
    case unableToCreateURLForURLRequest
    case  rateLimitExceeded
}

class APIService {

    let apiKey = "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"
    
    func fetchImageForPrompt(_ prompt: String) async throws -> UIImage {
        let fetchImageURL = "https://api.openai.com/v1/images/generations"
        let urlRequest = try createURLRequestFor(httpMethod: "POST", url: fetchImageURL, prompt: prompt,isDalE: true)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        let decoder = JSONDecoder()
        let results = try decoder.decode(DalleResponse.self, from: data)

        let imageURL = results.data[0].url
        guard let imageURL = URL(string: imageURL) else {
            throw APIError.unableToCreateImageURL
        }

        let (imageData, imageResponse) = try await URLSession.shared.data(from: imageURL)

        guard let image = UIImage(data: imageData) else {
            throw APIError.unableToConvertDataIntoImage
        }

        return image
    }

    private func createURLRequestFor(httpMethod: String, url: String, prompt: String, isDalE: Bool ) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw APIError.unableToCreateURLForURLRequest
        }

        var urlRequest = URLRequest(url: url)

        // Method
        urlRequest.httpMethod = httpMethod

        // Headers
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")



        // Body
//        if isDalE{
//            let jsonBody: [String: Any] = [
//                "prompt": "\(prompt)",
//                "n": 1,
//                "size": "1024x1024"
//            ]
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
//        }else{
//            let jsonBody: [String: Any] = [
//                "model": "text-davinci-003",
//                "prompt": "\(prompt)",
//                "max_tokens": 1500,
//                 "top_p": 10,
//                 "frequency_penalty": 0.0,
//                 "presence_penalty": 0.6,
//                 "stop": [" Human:", " AI:"]
//
//            ]
//
//
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
//        }
        if isDalE {
                   let jsonBody: [String: Any] = [
                       "prompt": "\(prompt)",
                       "n": 1,
                       "size": "1024x1024"
                   ]
                   urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
               } else {
                   let jsonBody: [String: Any] = [
                       "model": "gpt-3.5-turbo",
                       "messages": [
                           [
                               "role": "system",
                               "content": "You are a helpful assistant."
                           ],
                           [
                               "role": "user",
                               "content": "\(prompt)"
                           ]
                       ]
                   ]
                   urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
               }

        return urlRequest
    }

    func sendPromtToGpt(promt: String) async throws -> String{
//        let completion = "https://api.openai.com/v1/completions"
        let completion = "https://api.openai.com/v1/chat/completions"
   

        let urlRequest = try   createURLRequestFor(httpMethod: "POST", url: completion, prompt: promt, isDalE: false)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print(response)
        print("\(data)")

        let results = try JSONDecoder().decode(GPTResponse.self, from: data)
        return results.choices[0].message.content
    }
}





