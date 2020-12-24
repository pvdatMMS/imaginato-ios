//
//  UserSharePreference.swift
//  Imaginato
//
//  Created by Phan Van Dat on 12/24/20.
//

import KeychainAccess

enum UserKeys {
    static let kUsername                  = "username"
}

class UserSharePreference {
    
    //MARK: Shared Instance
    static let shared: UserSharePreference = {
        let instance = UserSharePreference()
        return instance
    }()
    
    let keychain: Keychain
    
    //MARK: -  Init
    init() {
        keychain  =  Keychain(service: "com.mmsofts.imaginato")
    }
    
    // MARK: store
    func save(key: String, value: String?) {
        keychain[key] = value
    }
    
    func removeUsername(completion : @escaping (_ Success : Bool) -> ()) {
        let keys = keychain.allKeys()
        for key in keys {
            do {
                if key == UserKeys.kUsername {
                    try keychain.remove(key)
                }
            } catch _ {
                // Error handling if needed...
            }
        }
        completion(true)
    }
}
