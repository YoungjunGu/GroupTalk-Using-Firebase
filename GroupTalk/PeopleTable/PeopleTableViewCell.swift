//
//  PeopleTableViewCell.swift
//  GroupTalk
//
//  Created by youngjun goo on 20/02/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var post: Post?
    
    func setUserInfoConfig(post: Post) {
        self.post = post
        
        self.profileImage.image = nil
        ImageService.getImage(withURL: post.author.photoURL) { image, url in
            guard let postCheck = self.post else { return }
            if postCheck.author.photoURL.absoluteString == url.absoluteString {
                self.profileImage.image = image
            } else {
                print("People Table Image 업로드 실패")
            }
        }
        
        nameLabel.text = post.author.userName
    }

}
