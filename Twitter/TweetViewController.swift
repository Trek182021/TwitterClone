//
//  TweetViewController.swift
//  Twitter
//
//  Created by Trek on 9/29/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var image: UIImageView!
    

    @IBAction func tweet(_ sender: Any) {
        if (!tweetText.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetText.text, success: {print("Success")}, failure: {
                (Error) in print("Couldn't post tweet\(Error)")
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetText!.layer.borderWidth = 1
        tweetText.layer.cornerRadius = 8.0
        tweetText!.layer.borderColor = UIColor.black.cgColor
        
        image.layer.cornerRadius = 8.0
        image.clipsToBounds = true
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
