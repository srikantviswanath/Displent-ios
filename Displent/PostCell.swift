//
//  PostCell.swift
//  Displent
//
//  Created by Srikant Viswanath on 4/25/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    
    var networkRequest: Request?
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var descriptionText: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
    }

    func configureCell(post:Post, img: UIImage?){
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        if img != nil{
            self.showcaseImg.image = img
        }else{
            if let imgUrl = post.imageUrl{
                networkRequest = Alamofire.request(.GET, imgUrl).validate(contentType: ["image/*"]).response(completionHandler: {
                    request, response, data, err in
                    if err == nil{
                        let downloadedImg = UIImage(data: data!)!
                        self.showcaseImg.image = downloadedImg
                        HomeFeedVC.imageCache.setObject(downloadedImg, forKey: imgUrl)
                    }
                })
            }else{
                self.showcaseImg.hidden = true
            }
        }
    }
}
