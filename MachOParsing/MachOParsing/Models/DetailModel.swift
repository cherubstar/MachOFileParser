//
//  DetailModel.swift
//  MachOParsing
//
//  Created by 小七 on 2023/11/26.
//

import Foundation
import SwiftUI

struct DetailModel: Identifiable, Codable {
    
    let id: String
    let offset: String
    let data: String
    let description: String
    let value: String
    
    init(id: String = UUID().uuidString, offset: String, data: String, description: String, value: String) {
        self.id = id
        self.offset = offset
        self.data = data
        self.description = description
        self.value = value
    }
    
}
