//
//  ACTextView.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-29.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import UIKit

class ACTextView: UITextView {
    
    var placeholder: NSString! {
        willSet(newValue) {
            if !newValue.isEqualToString(placeholder) {
                self.updateShouldDrawPlaceholder()
            }
        }
    }
    var placeholderTextColor: UIColor!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: self)
        self.removeObserver(self, forKeyPath: "text", context: nil)
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        // Initialization code
        self.initialize()
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        super.drawRect(rect)
        
        if shouldDrawPlaceholder {
            placeholderTextColor.set()
            placeholder.drawInRect(CGRectMake(8.0, 8.0, self.width - 16.0, self.height - 16.0), withAttributes: [NSForegroundColorAttributeName: placeholderTextColor, NSFontAttributeName: self.font])
        }
    }

    
    private var shouldDrawPlaceholder: Bool = NO
    //私有
    private func initialize() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: self)
        self.addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.New, context: nil)
        self.placeholderTextColor = UIColor(white: 0.702, alpha: 1.0)
        shouldDrawPlaceholder = NO
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>) {
        if keyPath == "text" {
            self.updateShouldDrawPlaceholder()
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    private func updateShouldDrawPlaceholder() {
        var prev = shouldDrawPlaceholder
        shouldDrawPlaceholder = self.placeholder && self.placeholderTextColor && countElements(self.text!) <= 0
        
        if prev != shouldDrawPlaceholder {
            self.setNeedsDisplay()
        }
    }
    
    private func textChanged(notification: NSNotification) {
        self.updateShouldDrawPlaceholder()
    }

}
