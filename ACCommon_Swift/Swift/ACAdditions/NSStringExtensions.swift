//
//  NSStringExtensions.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-31.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import Foundation
import MobileCoreServices

extension NSString {
    
    /**
    字符串格式化
    */
    func format(args: CVarArg...) -> NSString {
        return NSString(format: self, arguments: getVaList(args))
    }
    
    //#pragma mark - md5
    
    /**
    md5加密
    */
    func md5() -> NSString {
        
        let plaintext = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let plaintextLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(plaintext!, plaintextLen, result)
        
        var md5Hash = NSMutableString(string: "")
        for i in 0..<digestLen {
            md5Hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(md5Hash)
    }
    
    //#pragma mark - Base64
    
    /**
    Base64加密
    */
    func encodeBase64() -> NSString {
        var data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        data = GTMBase64.encodeData(data)
        var base64String = NSString(data: data, encoding: NSUTF8StringEncoding)
        return base64String
    }
    
    /**
    Base64解密
    */
    func decodeBase64() -> NSString {
        var data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        data = GTMBase64.decodeData(data)
        var base64String = NSString(data: data, encoding: NSUTF8StringEncoding)
        return base64String
    }
    
    //#pragma mark - String Validate
    
    private func regularWithPattern(pattern: NSString) -> Bool {
        if pattern != nil && !pattern.validateNotNull() {
            return false
        }
        var error: NSError? = nil
        var regex = NSRegularExpression.regularExpressionWithPattern(pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
        
        var options = NSMatchingOptions.Anchored | NSMatchingOptions.ReportCompletion | NSMatchingOptions.ReportProgress
        var number = regex.numberOfMatchesInString(self, options: options, range: NSMakeRange(0, self.length))
        return (number == 1)
    }
    /**
    字符串验证
    */
    func validateEmail() -> Bool {
        
        return self.regularWithPattern("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
    
    func validateCarNo() -> Bool {
        
        return self.regularWithPattern("^[\u{4e00}\u{9fa5}{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u{4e00}\u{9fa5}$")
    }
    
    func validateNumber() -> Bool {
        return self.regularWithPattern("^[0-9]+$")
    }
    
    func validateMobile() -> Bool {
        
        return self.regularWithPattern("^((13[0-9])|(14[57])|(15[^4\\D])|(17[0678])|(18[0-9]))\\d{8}$")
    }
    
    func validateNotNull() -> Bool {
        
        if !self.isKindOfClass(NSClassFromString("NSString")) {
            return false
        }
        var tempString: NSString = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).bridgeToObjectiveC()
        if tempString.isEqualToString("") {
            return false
        }
        return true
    }
    
    func validateCarType() -> Bool {
        
        return self.regularWithPattern("^[\u{4E00}\u{9FFF}+$")
    }
    
    func validateLandline() -> Bool {
        
        return self.regularWithPattern("^(0[1-9]{2})-\\d{8,10}$|^(0[1-9]{3}-(\\d{7,10}))$|^(0[1-9]{2})\\d{8,10}$|^(0[1-9]{3}(\\d{7,10}))$")
    }
    
    func validateUserName() -> Bool {
        
        return self.regularWithPattern("^[A-Za-z0-9]{6,20}+$")
    }
    
    func validateURLString() -> Bool {
        
        return self.regularWithPattern("^[0-9]+$")
    }
    
    func validateCharacters() -> Bool {
        
        return self.regularWithPattern("[\u{4e00}\u{9fa5}+")
    }
    
    func validateDoubleByte() -> Bool {
        
        return self.regularWithPattern("[^\\x00-\\xff]+")
    }
    
    func validateFloatNumber() -> Bool {
        
        return self.regularWithPattern("^([-+]?([1-9]\\d*\\.\\d*))|([-+]?0\\.\\d*[1-9]\\d*)$")
    }
    
    func validateIdentityCard() -> Bool {
        
        return self.regularWithPattern("^(\\d{14}|\\d{17})(\\d|[xX])$")
    }
    
    
    //#pragma mark - String Drawing
    
    /**
    字符串绘制成图片
    */
    func drawImageWithSize(size: CGSize, font: UIFont, color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        self.drawInRect(CGRect(origin: CGPointZero, size: size), withAttributes: [NSFontAttributeName: font,NSForegroundColorAttributeName: color])
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //#pragma mark - 字符串size计算
    
    /**
    计算文本size 只针对单行
    @font 字体
    */
    func computeSizeWithFont(font: UIFont) -> CGSize {
        if !self.isKindOfClass(NSClassFromString("NSString")) || font == nil {
            return CGSizeZero
        }
        var size = self.sizeWithAttributes([NSFontAttributeName: font])
        return size
    }
    
    /**
    计算文本宽度 只针对多行
    @font 字体
    @height 默认高度
    */
    func computeWidthWithFont(font: UIFont, height: CGFloat) -> CGFloat {
        if !self.isKindOfClass(NSClassFromString("NSString")) || font == nil {
            return 0.0
        }
        
        var size = self.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
        var newHeight: CGFloat = size.height
        var width: CGFloat = size.width
        if height > newHeight {
            var row: NSInteger = NSInteger(floor((height / newHeight)))
            
            width = ceil(width / CGFloat(row)) + 5.0
        }
        
        return width
    }
    
    /**
    计算文本的高度 只针对多行
    @font 字体
    @width 默认宽度
    */
    func computeHeightWithFont(font: UIFont, width: CGFloat) -> CGFloat {
        if !self.isKindOfClass(NSClassFromString("NSString")) || font == nil {
            return 0.0
        }
        var height: CGFloat = CGRectGetHeight(self.boundingRectWithSize(CGSizeMake(width, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil))
        
        return height
    }
    
    //#pragma mark - MIME
    
    /**
    返回指定路径下文件的MIME
    */
    //引至ASIHTTPRequst #import <MobileCoreServices/MobileCoreServices.h>
//    func fileMIMEType(file: NSString) -> NSString {
//        
//        if !NSFileManager.defaultManager().fileExistsAtPath(file) {
//            return ""
//        }
//        
//        // Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
//        var UTI: CFStringRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (file.pathExtension as CFString), nil).takeRetainedValue()
//        var MIMEType: CFStringRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType).takeRetainedValue()
//        if (MIMEType as NSString) == nil {
//            return "application/octet-stream"
//        }
//        return MIMEType as NSString
//    }
    
    //#pragma mark - NSString To UIImage
    func stringConvertedImage() -> UIImage {
        var data = GTMBase64.decodeString(self)
        return UIImage(data: data)
    }
    
    //#pragma mark - JSON
    func JSON() -> AnyObject! {
        var data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        if !data {
            return nil
        }
        
        return data.JSON()
    }
}