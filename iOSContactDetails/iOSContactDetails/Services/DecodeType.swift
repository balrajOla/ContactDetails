//
//  DecodeType.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 28/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
import PromiseKit

protocol DecodeTypeProtocol {
    func decode<T: Decodable>(response: Promise<Data>) -> Promise<T>
}

struct DecodeType: DecodeTypeProtocol {
    func decode<T: Decodable>(response: Promise<Data>) -> Promise<T> {
        return response.compactMap(on: DispatchQueue.global(qos: .utility)) { try JSONDecoder().decode(T.self, from: $0) }
    }
}
