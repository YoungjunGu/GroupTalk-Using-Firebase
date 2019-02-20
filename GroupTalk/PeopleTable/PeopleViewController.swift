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

class PeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var tableView: UITableView!
    
    
    var cellIdentifier: String = "Cell"
    var posts = [Post]()
    var fetchingMore = false
    var endReached = false
    let leadingScreenForBatching: CGFloat = 3.0
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "PeopleTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: self.cellIdentifier)
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.addSubview(tableView)
        
        var layoutGuide:UILayoutGuide!
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        beginBatchFetch()
    }
    
    func fetchPosts(completion: @escaping (_ posts: [Post]) -> ()) {
        let postsRef = Database.database().reference().child("posts")
        var queryRef:DatabaseQuery
        let lastPost = posts.last
        if lastPost != nil {
            let lastTimestamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp).queryLimited(toLast: 20)
        } else {
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 20)
        }
        
        queryRef.observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Post]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    let photoURL = author["photoURL"] as? String,
                    let url = URL(string:photoURL),
                    let timestamp = dict["timestamp"] as? Double {
                    
                    if childSnapshot.key != lastPost?.userId {
                        let userProfile = User(uid: uid, userName: username, photoURL: url)
                        let post = Post(userId: childSnapshot.key, author: userProfile, timestamp: timestamp)
                        tempPosts.insert(post, at: 0)
                    }
                    
                }
            }
            
            return completion(tempPosts)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PeopleTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! PeopleTableViewCell
        cell.setUserInfoConfig(post: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 72.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreenForBatching {
            
            if !fetchingMore && !endReached {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        
        fetchPosts { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.fetchingMore = false
            self.endReached = newPosts.count == 0
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }
    }
    
}
