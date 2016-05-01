//
//  HomeFeedVC.swift
//  Displent
//
//  Created by Srikant Viswanath on 4/25/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class HomeFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var newPostDesc: MaterialTextField!
    @IBOutlet weak var newPostImgPreview: UIImageView!
    
    @IBAction func selectImageToUpload(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createPost(sender: AnyObject) {
        if let postTxt = newPostDesc.text where postTxt != "" {
            let urlStr = "https://post.imageshack.us/upload_api.php"
            let url = NSURL(string: urlStr)!
            let imgData = UIImageJPEGRepresentation(newPostImgPreview.image!, 0.2)!
            let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
            let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
            Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "newImage", mimeType: "image/jpg")
                multipartFormData.appendBodyPart(data: keyData, name: "key")
                multipartFormData.appendBodyPart(data: keyJSON, name: "format")
            }){ encodingResult in
                switch encodingResult{
                case .Success(let upload, _, _):
                    upload.responseJSON(completionHandler: { rawResponseDict in
                        if let masterResponseDict = rawResponseDict.result.value as? Dictionary<String, AnyObject>{
                            if let imgLinks = masterResponseDict["links"] as? Dictionary<String, String>{
                                print(imgLinks["image_link"]!)
                            }
                        }
                    })
                case .Failure(let error):
                    print("Could not upload image to server: \(error)")
                }
            }
            
        }
        
    }
    static var imageCache = NSCache()
    var postsList = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 364
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.dataService.REF_POSTS.observeEventType(.Value, withBlock:{ snapshot in
            self.postsList = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let postKey = snap.key
                        let post = Post(postKey: postKey, postDict: postDict)
                        self.postsList.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell{
            cell.networkRequest?.cancel()
            let post = postsList[indexPath.row]
            var img: UIImage?
            if let imgUrl = post.imageUrl{
                img = HomeFeedVC.imageCache.objectForKey(imgUrl) as? UIImage
            }
            cell.configureCell(post, img: img)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = postsList[indexPath.row]
        if (post.imageUrl == nil || post.imageUrl == "") {
            return 150
        }else{
            return tableView.estimatedRowHeight
        }
    }
    
    /*ImagePickerController Delegate methods*/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        newPostImgPreview.image = image
    }
}
