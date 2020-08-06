//
//  RootViewController.swift
//  SocialFeed
//
//  Created by Rajender Sharma on 26/06/20.
//  Copyright © 2020 Rajender Sharma. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SDWebImage
import FBSDKCoreKit

class RootViewController: UIViewController {
	var posts:NSArray? = NSArray()

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self

			tableView.estimatedRowHeight = 100
			tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
		}
	}


	func maximum(nums:[Int]) -> Int {
        let maxResult = 0;
        var mask = 0;
		for i in 31...0 {
            mask |= (1 << i);
            var set = Set<[Int]>()
			for num in nums {
				set.hashValue = (num | mask)
			}
			let greedyTry = maxResult | (1 << i);
			for num in set {
                if(set.contains(greedyTry ^ num)) {
                    maxResult = greedyTry;
                    break;
                }
            }
		}
        return maxResult;

	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.configureUI()
		self.maximum(num: [1, 2, 3, 4, 5, 6, 7, 8])
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	//MARK: Private Methods
	private func configureUI() {
		self.title = "Newsfeed"
		getAccessToken()
	}


	func getAccessToken() {
		//https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id={app-id}& client_secret={app-secret}&fb_exchange_token={short-lived-user-access-token}"
		let parameters = ["grant_type":"fb_exchange_token", "client_id":"2655100154702853", "client_secret":"{fa7c4e1e5173565a3ee01510992ace38}", "fb_exchange_token":"{EAAgF6ZApKtQ0BAPUZBRvRjOU2bp4D0D0QdOdSE4ZAUmXhZCFkWBxD3xpgvvPgTnj7GaO7ARz5pMARzdIsZARzCzaGIPiCphtUKmTw8wY4xngCT3cIxzze3T9ZCku90JzYzDCIgBhEE13pw4aUemgrtZCms2Eb8yUQJxS8kraRHGXZCWPhXJZCTaxRiSJZAoMjr5lA94p8PPZA7D8wZDZD}"]

		let path = "/oauth/access_token"
		self.showProgressHUD()

		let numbers = "1 2 3 4"
		let new = numbers.comb


		let request = FBSDKCoreKit.GraphRequest(graphPath: path, parameters: parameters, httpMethod: HTTPMethod.post)
		request.start { (connection, response, error) in

			self.hideProgressHUD()
			print(response)
			self.getPosts()
		}

	}

	func getPosts() {
		let pageName = "rajender.sharma09"
		let path = "/\(pageName)/posts"
		self.showProgressHUD()

		let request = FBSDKCoreKit.GraphRequest(graphPath: path, parameters: ["fields": "id, attachments, caption, child_attachments, description, from, full_picture, icon, message, message_tags, name, permalink_url, properties, status_type, story"])
		request.start { (connection, response, error) in

			self.hideProgressHUD()
			print(response)
		}
	}
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let posts = self.posts else {
			return 0
		}
		return posts.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.view.frame.height * 0.75
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		var cell:FBFeedCell? = self.tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell") as? FBFeedCell
		if cell == nil {
			tableView.register(UINib(nibName: "FBFeedCell", bundle: nil), forCellReuseIdentifier: "FBFeedCell")
			cell = tableView.dequeueReusableCell(withIdentifier: "FBFeedCell") as? FBFeedCell
		}

		let post = self.posts?.object(at: indexPath.row) as? [String:AnyObject]
		let type = post?["type"] as? String
		cell?.titleLabel.text = post?["title"] as? String
        cell?.detailLabel.attributedText = nil

        //cell?.itemDesc.attributedText = "<figure class=\"tmblr-full\" data-orig-height=\"648\" data-orig-width=\"599\"><img src=\"https://68.media.tumblr.com/cc463a5515eaf11d267409f2bb944e74/tumblr_inline_orx2xwgvBS1tmofyy_540.gif\" data-orig-height=\"648\" data-orig-width=\"599\"/></figure><p>EVERYTHING IN MODERATION&hellip;.</p>".html2AttributedString
		if type == "photo" {
			let photos = post?["photos"] as? NSArray
			let allSizes:NSDictionary = photos?.object(at: 0) as! NSDictionary
			let originalSize = allSizes["original_size"] as? NSDictionary

			cell?.feedImage.sd_setImage(with: URL(string: originalSize?["url"] as! String), placeholderImage: UIImage(named: "images"), options:.highPriority, completed: { (image, error, cache, url) in

				if error == nil {
					cell?.feedImage.image = image
				}
				else{
					print(error!.localizedDescription)
				}
			})
//			cell?.feedImage.sd_setShowActivityIndicatorView(true)
//			cell?.feedImage.sd_setIndicatorStyle(.whiteLarge)
		}
        else {
            cell?.imageView?.image = nil
            cell?.detailLabel.attributedText = (post?["body"] as? String)?.html2AttributedString
        }

        cell?.selectionStyle = .none
		return cell!
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
