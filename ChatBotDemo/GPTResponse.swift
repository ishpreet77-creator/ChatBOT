//
//  GPTResponse.swift
//  Dall-E 2
//
//  Created by John on 17/02/23.
//

import Foundation
//struct GPTResponse: Decodable{
//    let choices: [GPTCompletion]
//}
//struct GPTCompletion : Decodable{
//    let text: String
//    let finishReason: String
//}


struct GPTResponse: Codable {
    let choices: [GPTCompletion]
    let created: Int
    let id: String
    let model: String
    let object: String
    let usage: Usage
}

struct GPTCompletion: Codable {
    let finish_reason: String
    let index: Int
    let message: Message
}

struct Message: Codable {
    let content: String
    let role: String
}

struct Usage: Codable {
    let completion_tokens: Int
    let prompt_tokens: Int
    let total_tokens: Int
}
