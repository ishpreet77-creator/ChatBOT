//
//  DallE.swift
//  Dall-E 2
//
//  Created by John on 17/02/23.
//

import Foundation

struct DalleResponse: Decodable {
    let data: [ImageURL]
}

struct ImageURL: Decodable {
    let url: String
}
