//
//  LoginViewModel.swift
//  Imaginato
//
//  Created by Phan Van Dat on 12/23/20.
//

import Foundation
import RxSwift
import RxRelay
import Then
import Alamofire

class LoginViewModel {
    
    var emailText = BehaviorRelay(value: "")
    var passwordText = BehaviorRelay(value: "")
    
    var isValidEmail: Observable<Bool> {
        return self.emailText.asObservable().map { email in
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
    }
    
    var isValidPassword: Observable<Bool> {
        return self.passwordText.asObservable().map {
            password in
            let passwordRegEx = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{3,16}$"
            let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
            return passwordPred.evaluate(with: password)
        }
    }
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(isValidEmail, isValidPassword) {$0 && $1}
    }
    
    func login(_ email: String, _ password: String) -> Promise<Any> {
        let path = NetworkConfig.kLogin
        let parameters = ["email": email, "password": password]
        return Promise { fulfill, reject in
            AF.request(path, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let json = value as? [String: Any] {
                            fulfill(json["data"]!)
                        }
                    case .failure(let error):
                        reject(error)
                    }
                }
        }
    }
}
