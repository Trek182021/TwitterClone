//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Trek on 9/24/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets = 10
    
    let myRefreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()

        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    @objc func loadTweets() {
        numberOfTweets = 20
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success:
        {(tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: {(Error) in print("Could not retrieve tweets \(Error)")})
    }
    
    func loadMoreTweets() {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = self.numberOfTweets + 10
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: {(tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: {(Error) in print("Could not retrieve tweets \(Error)")})
        
    }
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion:nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let tweet = tweetArray[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        cell.tweetLabel.text = tweet["text"] as? String
        cell.userNameLabel.text = user["name"] as? String
        let screenName = user["screen_name"] as! String
        cell.screenName.text = "@\(screenName)"
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorited(tweet["favorited"] as! Bool)
        cell.tweetId = tweet["id"] as! Int
        cell.setReTweet(tweet["retweeted"] as! Bool)
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}
