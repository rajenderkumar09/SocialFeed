//
//  UIFont+Extensions.swift
//  SocialFeed
//
//  Created by Rajender Sharma on 26/06/20.
//  Copyright © 2020 Rajender Sharma. All rights reserved.
//

import Foundation
import UIKit


extension UIFont {
    static func appFont(with weight: UIFont.Weight, size: CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: size, weight: weight)
    }
}
