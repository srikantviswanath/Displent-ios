//
//  Post.swift
//  Displent
//
//  Created by Srikant Viswanath on 4/26/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import Foundation

class Post {
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    
    var postDescription: String{
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var username: String{
        return _username
    }
    
    var postKey: String{
        return _postKey
    }
    
    var likes: Int{
        return _likes
    }
    
    /*init for a shell object before writing to Firebase. Hence doesnt have postKey*/
    init(description: String, imgUrl: String?, username: String){
        self._postDescription = description
        self._imageUrl = imgUrl
        self._username = username
    }
    
    /*init to create an instance of Post after grabbing Firebase post object and parsing the dictionary*/
    init(postKey: String, postDict: Dictionary<String, AnyObject>){
        self._postKey = postKey
        if let likes = postDict["likes"] as? Int {self._likes = likes}
        if let imgUrl = postDict["imgUrl"] as? String {self._imageUrl = imgUrl}
        if let postDesc = postDict["description"] as? String {self._postDescription = postDesc}
    }
}