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

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.configureUI()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	//MARK: Private Methods
	private func configureUI() {
		self.title = "Newsfeed"
		self.getPosts()
	}

	func getPosts() {
		let pageName = "rajender.sharma09"
		let path = "/\(pageName)/posts"
		self.showProgressHUD()

		let request = FBSDKCoreKit.GraphRequest(graphPath: path, parameters: ["fields": "name, email, friends"])
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
