//
//  LocalUser.swift
//  Imaginato
//
//  Created by Phan Van Dat on 12/24/20.
//

import Foundation
import RealmSwift

class LocalUser: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var userID: Int = 0
    @objc dynamic var username: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    
    static func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(LocalUser.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    
    static func create(user: User) -> LocalUser {
        let localUser = LocalUser()
        localUser.id = incrementID()
        localUser.username = user.username
        localUser.userID = user.userID
        localUser.createdAt = Date()
        localUser.updatedAt = Date()
        return localUser
    }
}
