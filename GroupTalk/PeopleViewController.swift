//
//  HomeViewController.swift
//  GroupTalk
//
//  Created by youngjun goo on 15/02/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userList: [User] = []
    var tableView: UITableView?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let imageView = UIImageView()
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(cell)
            m.height.width.equalTo(50)
        }
        URLSession.shared.dataTask(with: URL(string: userList[indexPath.row].profileImageURL!)!) { (data, response, error) in
            
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data!)
                imageView.layer.cornerRadius = imageView.frame.size.width/2
                imageView.clipsToBounds = true
            }
        }.resume()
        
        let label = UILabel()
        cell.addSubview(label)
        label.snp.makeConstraints{ (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(imageView.snp.right).offset(30)
        }
        
        label.text = userList[indexPath.row].userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        //tableView Setting
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints{ (m) in
            m.top.equalTo(view).offset(20)
            m.bottom.left.right.equalTo(view)
        }
        
        Database.database().reference().child("user").observe(DataEventType.value, with: { (snapShot) in
            
            //중복을 없애기 위함
            self.userList.removeAll()
            for child in snapShot.children {
                let fchild = child as! DataSnapshot
                let userModel = User()
                
                userModel.setValuesForKeys(fchild.value as! [String: Any])
                self.userList.append(userModel)
            }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        })
        
        func showAlert(message: String) {
            
            let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
