//
//  ACTableViewCell.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-29.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import UIKit

struct ACSeparatorSpaces {
    var left: CGFloat
    var right: CGFloat
}

func ACSeparatorSpacesMake(left: CGFloat, right: CGFloat) -> ACSeparatorSpaces {
    var spaces = ACSeparatorSpaces(left: left, right: right)
    return spaces
}

func ACSeparatorSpacesEqualToSeparatorSpaces(spaces1: ACSeparatorSpaces, spaces2: ACSeparatorSpaces) -> Bool {
    return spaces1.left == spaces2.left && spaces1.right == spaces2.right
}

var ACSeparatorSpacesZero = ACSeparatorSpaces(left: 0.0, right: 0.0)

class ACTableViewCell: UITableViewCell {
    
    var showingSeparator: Bool = NO {
        willSet(newValue) {
            if newValue != showingSeparator {
                self.setNeedsDisplay()
            }
        }
    }
    var separatorSpace: ACSeparatorSpaces = ACSeparatorSpacesZero {
        willSet(newValue) {
            if !ACSeparatorSpacesEqualToSeparatorSpaces(newValue, separatorSpace) {
                self.setNeedsDisplay()
            }
        }
    }
    var separatorColor: UIColor! {
        willSet(newValue) {
            if newValue != separatorColor {
                self.setNeedsDisplay()
            }
        }
    }

    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        self.initialize()
    }
    
    func initialize() {
        showingSeparator = YES
        separatorColor = UIColor.grayColor().colorWithAlphaComponent(0.7)
        separatorSpace = ACSeparatorSpacesMake(15.0, 0.0)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if showingSeparator {
            var context = UIGraphicsGetCurrentContext()
            CGContextSetStrokeColorWithColor(context, separatorColor.CGColor)
            CGContextSetLineWidth(context, 1.0)
            //        CGFloat lineLength = CGRectGetWidth(rect) - _separatorSpace.left - _separatorSpace.right;
            var p1 = CGPointMake(separatorSpace.left, CGRectGetHeight(rect) - 1.0)
            var p2 = CGPointMake(CGRectGetWidth(rect) - separatorSpace.right, CGRectGetHeight(rect) - 1.0)
            
            CGContextMoveToPoint(context, p1.x, p1.y)
            CGContextAddLineToPoint(context, p2.x, p2.y)
            CGContextStrokePath(context)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
