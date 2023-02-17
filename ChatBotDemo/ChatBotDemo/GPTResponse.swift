//
//  GPTResponse.swift
//  Dall-E 2
//
//  Created by John on 17/02/23.
//

import Foundation
struct GPTResponse: Decodable{
    let choices: [GPTCompletion]
}
struct GPTCompletion : Decodable{
    let text: String
    let finishReason: String
}
