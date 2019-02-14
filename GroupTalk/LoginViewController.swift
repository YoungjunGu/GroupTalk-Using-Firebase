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

    //firebase의 내용을 원격으로 가져옴
    let remoteConfig = RemoteConfig.remoteConfig()
    var colorString: String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        setUpLayout()
        
        //현재 유저가 로그인 중 인지 확인 하는 작업
        if Auth.auth().currentUser != nil {
            showAlert(message: "이미 로그인 된 상태입니다.")
        }
        
    }
    
    

}

extension LoginViewController {
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true, completion: nil)
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
}
