//
//  String+Extensions.swift
//  SocialFeed
//
//  Created by Rajender Sharma on 26/06/20.
//  Copyright © 2020 Rajender Sharma. All rights reserved.
//

import Foundation

extension String {

    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {

            return try NSAttributedString(data: data, options:[NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)

        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }

    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
