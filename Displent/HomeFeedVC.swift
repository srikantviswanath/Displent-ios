//
//  HomeFeedVC.swift
//  Displent
//
//  Created by Srikant Viswanath on 4/25/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit
import Firebase


class HomeFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postsList = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
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
        let post = postsList[indexPath.row]
        print(post.postDescription)
        return tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
    }
}
