//
//  HashTagTextView.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

var hashtagArr:[String]?

extension String {
    func getHashtags() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.rangeAt(1))
        })
    }
}

extension UITextView {
    func resolveHashTags(){
        self.isEditable = false
        self.isSelectable = true
        let nsText:NSString = self.text as NSString
        let attrString = NSMutableAttributedString(string: nsText as String)
        hashtagArr = self.text.getHashtags()
        
        if(hashtagArr?.count != 0) {
            var i = 0
            for var word in hashtagArr! {
                word = "#" + word
                if word.hasPrefix("#") {
                    let matchRange:NSRange = nsText.range(of: word as String)
                    attrString.addAttribute(NSLinkAttributeName, value: "\(i):", range: matchRange)
                    i += 1
                }
            }
        }
        self.attributedText = attrString
    }
}
