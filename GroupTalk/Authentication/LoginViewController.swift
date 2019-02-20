//
//  LoginViewController.swift
//  
//
//  Created by youngjun goo on 27/01/2019.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var signInButton: RoundedWhiteButton!
    @IBOutlet weak var cancelButton: RoundedWhiteButton!
    
    //firebase의 내용을 원격으로 가져옴
    let remoteConfig = RemoteConfig.remoteConfig()
    var colorString: String! = nil
    
    @IBAction func tapSignInButton(_ sender: Any) {
        
        if self.checkUserInputInfo() != false {
            handleSignIn()
        }
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! Auth.auth().signOut()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        setUpLayout()
        
        //현재 유저가 로그인 중 인지 확인 하는 작업
        if Auth.auth().currentUser != nil {
            showAlert(message: "이미 로그인 된 상태입니다.")
        }
        
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            if user != nil {
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewTabBarController") as! UITabBarController
                self.present(homeVC, animated: true, completion: nil)
                
            }
        }
        
    }
    
}

extension LoginViewController {
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func checkUserInputInfo() -> Bool {
        if self.emailTextField.text == "" {
            self.showAlert(message: "이메일을 입력해 주세요.")
            return false
        }
        else if self.pwdTextField.text == "" {
            self.showAlert(message: "비밀번호를 입력해 주세요.")
            return false
        }
        else {
            return true
        }
        
    }
    
    
    fileprivate func setUpLayout() {
        
        let stateBar = UIView()
        self.view.addSubview(stateBar)
        stateBar.snp.makeConstraints{ (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        colorString = remoteConfig["splash_background"].stringValue
        
        stateBar.backgroundColor = UIColor(named: colorString)
    }
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            signInButton.alpha = 1.0
            signInButton.isEnabled = true
        } else {
            signInButton.alpha = 0.5
            signInButton.isEnabled = false
        }
    }
    
    func handleSignIn() {
        guard let email = emailTextField.text else { return }
        guard let pass = pwdTextField.text else { return }
        
        setContinueButton(enabled: false)
        signInButton.setTitle("", for: .normal)
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("로그인 성공")
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                
                self.showAlert(message: "실패")
            }
        }
    }
}



