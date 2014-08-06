//
//  ACTextField.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-29.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import UIKit

class ACTextField: UITextField {
    var placeholderTextColor: UIColor! {
        willSet(newValue) {
            
            if self.text == nil && self.placeholder != nil {
                
                if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0 {
                    
                    var attributes = [NSForegroundColorAttributeName: newValue, NSFontAttributeName: self.font]
                    
                    var attributed: NSMutableAttributedString = NSMutableAttributedString(string: self.placeholder)
                    attributed.setAttributes(attributes, range: NSMakeRange(0, countElements(self.placeholder!)))
                    self.attributedPlaceholder = attributed
                }
                else {
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
    override func drawPlaceholderInRect(rect: CGRect)  {
        if self.placeholderTextColor != nil {
            super.drawPlaceholderInRect(rect)
            return
        }
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        paragraphStyle.alignment = self.textAlignment
        NSString(string: self.placeholder).drawInRect(rect, withAttributes: [NSForegroundColorAttributeName: self.placeholderTextColor,NSFontAttributeName: self.font,NSParagraphStyleAttributeName: paragraphStyle])
    }
}
