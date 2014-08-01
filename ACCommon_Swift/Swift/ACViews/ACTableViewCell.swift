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

//@infix 此关键字用于定义一个全局的运算符函数（双目运算符）
//这里只是写一个例子
@infix func +(spaces1: ACSeparatorSpaces, spaces2: ACSeparatorSpaces) -> ACSeparatorSpaces {
    return ACSeparatorSpaces(left: spaces1.left + spaces2.left, right: spaces1.right + spaces2.right)
}

//@prefix 此关键字用于定义一个前置运算符函数（如：-100,+100）(单目运算符)
@prefix func -(spaces: ACSeparatorSpaces) -> ACSeparatorSpaces {
    return ACSeparatorSpaces(left: -spaces.left, right: -spaces.right)
}

//@postfix 此关键字用于定义一个后置运算符函数（如：100--，100++）(单目运算符)
@postfix func --(spaces: ACSeparatorSpaces) -> ACSeparatorSpaces {
    return ACSeparatorSpaces(left: spaces.left - 1.0, right: spaces.right - 1.0)
}

//@assignment 此关键字用于定义一个组合赋值运算符函数（如：100 += 100），而且需将左参数用inout修饰，inout关键字表示此参数应该传入地址进行操作
@assignment func +=(inout spaces1:ACSeparatorSpaces, spaces2: ACSeparatorSpaces) {
    spaces1 = spaces1 + spaces2
}

//自定义运算符

//标准的运算符不够玩，那你可以声明一些个性的运算符，但个性的运算符只能使用这些字符 / = - + * % < >！& | ^。~。
//新的运算符声明需在全局域使用operator关键字声明，可以声明为前置，中置或后置的。
//operator prefix +++{}
//
//@prefix @assignment +++ (inout spaces1: ACSeparatorSpaces) -> ACSeparatorSpaces {
//    spaces1 += spaces1
//    return spaces1
//}

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
    
    private func initialize() {
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
