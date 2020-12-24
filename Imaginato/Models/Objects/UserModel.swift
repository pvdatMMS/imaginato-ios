//
//  UserModel.swift
//  Imaginato
//
//  Created by Phan Van Dat on 12/24/20.
//

import Foundation
import Arrow

struct User: ArrowParsable {
    var userID: Int = 0
    var username: String?
    var createdAt: String?
    
    mutating func deserialize(_ json: JSON) {
        userID <-- json["userId"]
        username <-- json["userName"]
        createdAt <-- json["created_at"]
    }
}
