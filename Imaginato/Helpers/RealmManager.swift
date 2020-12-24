//
//  RealmManager.swift
//  Imaginato
//
//  Created by Phan Van Dat on 12/24/20.
//

import Foundation
import RealmSwift

typealias UpdateRealmBlock = (_ realm: Realm) -> ()

extension Realm {
    static func write(updateBlock: UpdateRealmBlock) {
        Realm.block { (realm) in
            do {
                try realm.write { updateBlock(realm) }
            } catch { print("Cant write with realm", error) }
        }
    }
    
    static func block(updateBlock: UpdateRealmBlock) {
        do {
            let realm = try Realm()
            updateBlock(realm)
        } catch { print("Cant init realm object", error) }
    }
}

extension Object {
    static func fetchAll<ObjectType: Object>(query: String? = nil, date:NSDate? = nil ,_ type: ObjectType.Type) -> Results<ObjectType>? {
        var result: Results<ObjectType>?
        Realm.block { (realm) in
            if date == nil {
                let inspection = (query == nil ? realm.objects(type) : realm.objects(type).filter(NSPredicate(format: query!)) )
                result = inspection
            } else {
                let inspection = (realm.objects(type).filter(NSPredicate(format: "\(query!) %@", date!)) )
                result = inspection
            }
        }
        return result
    }
    
    func add() {
        Realm.write { realm in
            realm.add(self)
        }
    }
    
    func delete() {
        Realm.write { (realm) in
            realm.delete(self)
        }
    }
}
