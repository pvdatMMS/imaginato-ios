//
//  LoginViewController.swift
//  Imaginato
//
//  Created by Phan Van Dat on 12/23/20.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    
    let loginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup()
    {
        txtEmail.layer.cornerRadius = 15.0
        txtEmail.layer.borderWidth = 1.0
        txtEmail.layer.borderColor = UIColor.gray.cgColor
        txtEmail.layer.masksToBounds = true
        
        txtPassword.layer.cornerRadius = 15.0
        txtPassword.layer.borderWidth = 1.0
        txtPassword.layer.borderColor = UIColor.gray.cgColor
        txtPassword.layer.masksToBounds = true
        
        btnLogin.layer.cornerRadius = 20
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.black.cgColor
        
        _ = txtEmail.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.emailText)
        _ = txtPassword.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.passwordText)
        _ = loginViewModel.isValid.bind(to: btnLogin.rx.isEnabled)
        
        loginViewModel.isValid.subscribe(onNext: {[weak self] isValid in
            self?.btnLogin.alpha = isValid ? 1 : 0.4
            self?.btnLogin.isEnabled = isValid
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("complete")
        }).disposed(by: disposeBag)
    }
    
    @IBAction func onBeginEditingEmail(_ sender: Any) {
        _ = loginViewModel.isValidEmail.bind(to: lblEmailError.rx.isHidden)
    }
    
    @IBAction func onBeginEditingPassword(_ sender: Any) {
        _ = loginViewModel.isValidPassword.bind(to: lblPasswordError.rx.isHidden)
    }
    
    @IBAction func onTouchUpInsideLoginButton(_ sender: Any) {
        guard let email = txtEmail.text else {
            return
        }
        
        guard let password = txtPassword.text else {
            return
        }
        
        loginViewModel.login(email, password).then { response in
            guard let data = response as? [String: Any] else {
                return
            }
            
            if let user = data["user"] as? [String: Any] {
                let userID = user["userId"] as! Int
                let username = user["userName"] as! String
                
                let alert = UIAlertController(title: "Login Successful", message: "Hi, \(username)! Info: ID = \(userID) saved to realm.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
                var newUser = User()
                newUser.userID = userID
                newUser.username = username
                LocalUser.create(user: newUser).add()
            }
        }.onError { e in
            let alert = UIAlertController(title: "Login Failed", message: "Email or password incorrect!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
